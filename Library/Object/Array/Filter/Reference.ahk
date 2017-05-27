	;Reference Filters
	Class Template_SubFilter extends Lib.Obj.Array.Filter.Template {
		subFilter(byref F_Inst,Filter,Filter_ID,Eval:="",Extended_Output:=0)	{
			FID:=this.Sub_ID ==""?Filter_ID: this.Sub_ID "#" Filter_ID ;Creates Filter ID
			if(FID != Filter.Sub_ID) ;Checks if Filter ID is the same that's set to the FIlter
				Filter.Sub_ID:=this.generic.isKey(FID)?FID:Lib.Hash(FID) ;Sets Filter ID to Filter. If Filter ID can't be a variable then take a hash
			FEntry:={Filter:Filter,Eval:Eval==""?F_Inst.Eval:Eval,Filter_ID:Filter.Sub_ID}
			F_Inst.SubF_Parent.InsertAt(1,FEntry) ;Adds Filter Entry to Sub_Parent
			F_Inst.SubF_ID[Filter.Sub_ID]:=FEntry ;Adds Filter Entry to Sub_ID
			if(Extended_Output and isfunc(Filter.Filter_ext))
				FEntry.Output:=Filter.Filter_ext(F_Inst)
			else
				FEntry.Output:=Filter.Filter(F_Inst)
			F_Inst.SubF_Parent.RemoveAt(1) ;Removes Filter Entry from Sub_Parent - Finished running child filters
			return FEntry.Output
		}
	}
	Class Nest extends Lib.Obj.Array.Filter.Template_SubFilter {
		__New(SubFilter,Keys*)	{
			if(this.isFilter(SubFilter))	{
				this.Filter:=SubFilter
				if(Keys.Length() == 0)
					this.all_keys:=1
				else {
					this.Keys:=Array()
					this.Keys_Filter:=Array()
					For i,Key in Keys	
						if(this.isFilter(Key))
							this.Keys_Filter.push(Key)
						else if(this.generic.isKey(Key))
							this.Keys.push(Key)
				}
			}
		}
		Filter_ext(byref F_Inst)	{
			return this.Filter(F_Inst,1)
		}
		Filter(byref F_Inst,extended_output:=0) {
			if(isobject(F_Inst.Eval))			{
				if(this.all_keys) {
					For key,val in F_Inst.Eval {
						F_Inst.Key_Value.insertAt(1,{key:key,Value:val})
						output:=this.subFilter(F_Inst,this.Filter,val,key,extended_output)
						F_Inst.Key_Value.RemoveAt(1)
						if(output)
							return output
					}
				}
				else {
					if(this.Keys.Length() > 0) { ;Check Keys
						For i,Key in this.Keys {
							if(this.generic.hasKey(Key,F_Inst.Eval)) {
								val:=this.generic.get(Key,F_Inst.Eval)
								F_Inst.Key_Value.insertAt(1,{key:key,Value:val})
								output:=this.subFilter(F_Inst,this.Filter,val,this.Linear.join("_",Key),extended_output)
								F_Inst.Key_Value.RemoveAt(1)
								if(output)
									return output
							}
						}
					}
					if(this.Keys_Filter.length() > 0)		{ ;Check Key Filter
						For key,val in F_Inst.Eval {
							f_key:=0
							For ki,kFilter in this.Keys_Filter 
								if(this.subFilter(F_Inst,kFilter,key,"kf_" key "_" ki))
									f_key:=1,break
							if(f_key) {
								F_Inst.Key_Value.insertAt(1,{key:key,Value:val})
								output:=this.subFilter(F_Inst,this.Filter,val,key,extended_output)
								F_Inst.Key_Value.RemoveAt(1)
								if(output)
									return output
							}
						}
					}
				}
			}
			return 0
		}
	}
	Class Element extends Lib.Obj.Array.Filter.Template_SubFilter {
		__New(Element_Filter, ElementKeys_then_SubFilter*)	{
			If(this.isFilter(Element_Filter)) {
				this.Element_Filter:=Element_Filter 
				this.KFilter:=Array()
				keys:=Array()
				For i,Val in ElementKeys_then_SubFilter		{
					if(Val == "")
						keys.root:=1
					if(this.generic.isKey(Val))	;Checks for Key
						keys.push(Val)
					else if(lib.obj.array.filter.isFilter(Val))
						this.KFilter.push({Filter:Val,keys:keys}),keys:=Array()
				}
			}
		}
		Filter(byref F_Inst) {
			if(isobject(this.Element_Filter)) {
				Element_Output:=this.subFilter(F_Inst,this.Element_Filter,"Element",1)
				if(!Element_Output)
					return 0
				For i,KFil in this.KFilter {
					if(KFil.keys.length() == 0 or KFil.Root)
						if(this.subFilter(F_Inst,KFil.Filter,Element_Output, i "_"))
							return 1
					For ki,Key in KFil.Keys	
						if(this.subFilter(F_Inst,KFil.Filter, i (isobject(Key)?Lib.Obj.Array.Linear.Join("_",Key):Key),Lib.obj.Array.Generic.Get(Key,Element_Output)))
							return 1
				}
			}
			return 0
		}
	}
	Class byKey extends Lib.Obj.Array.Filter.Template_SubFilter {
		__New(Filter,depth:=1) {
				this.depth:=depth is digit and depth != ""?depth:1
				this.Filter:=this.isFilter(Filter)?Filter:""
		}
		Filter_ext(byref F_Inst) {
			return this.Filter(F_Inst,1)
		}
		Filter(byref F_Inst,extended_output:=0) {
			return isobject(this.Filter)?this.subFilter(F_Inst,this.Filter,F_Inst.Key_Value[ this.depth > F_Inst.Key_Value.length() ?F_Inst.Key_Value.Length():this.depth].Key,"Key",extended_output):0
		}
	}
	Class byValue extends Lib.Obj.Array.Filter.byKey {
		Filter(byref F_Inst,extended_output:=0) {
			return isobject(this.Filter)?this.subFilter(F_Inst,this.Filter,F_Inst.Key_Value[ this.depth > F_Inst.Key_Value.length() ?F_Inst.Key_Value.Length():this.depth].Value,"Value",extended_output):0
		}
	}
	
	