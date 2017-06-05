Class Filter extends Lib.Obj.Array {
	Call(Function,Filter_Options,Arr*){
		Options:=this.F_Options(Filter_Options,{Result_Mode:0})
		return isobject(Options)?this.Filter(Options,Arr*):""
	}
	Values(Filter_Options,Arr*){
		Options:=this.F_Options(Filter_Options,{Result_Mode:3})
		return isobject(Options)?this.Filter(Options,Arr*):""
	}
	Keys(Filter_Options,Arr*){
		Options:=this.F_Options(Filter_Options,{Result_Mode:2})
		return isobject(Options)?this.Filter(Options,Arr*):""
	}
	Filter(Options,Arr*)	{
		if(!isobject(Options) or !Options.HasKey("Filter") or !this.isFilter(Options.Filter))
			return
		Options.FTemplate:={FArr:this.F_Template(Options,"FArr_Template",{Filter:1,FK_Arr:Array(),Arr:""})	;Builds Filter Array Template
		,FKey:this.F_Template(Options,"FKey_Template",{Key_Value:"",eval:"",eval_result:""})} ;Builds Filter Key Template
		For i,sArr in Arr {
			F_Inst:=Options.clone()
			F_Inst.FArr:=this.F_Instance(Options.FTemplate.FArr,{Arr:sArr}) ;Builds Filter Array Instance
			While(F_Inst.FArr.filter) { ;Filter Evaluation
				F_Inst.FArr.filter:=0
				For k,v in sArr {
					if(Options.filter_meta or !Lib.Obj.isMeta(k,v))	{
						F_Inst.FKey:=this.F_Instance(Options.FTemplate.FKey,{Key_Value:[{Key:k,Value:v}],eval:Options.byKey?k:v}) ;Builds Filter Key Instance
						F_Inst.FKey.Eval_Result:=this.F_Eval(Options.Filter,F_Inst) ;Evaluates Filter
						F_Inst.FArr.FK_Arr[k]:=F_Inst.FKey ;Stores Filter In Filter Array Instance
					}
				}
			}
			if(Options.Result_Mode < -2) ;Result Unfiltered
				Arr[i]:=Options.Result_Mode == -3?F_Inst.FArr.FK_Arr:Options.Result_Mode == -4?F_Inst.FArr:F_Inst
			else if(Options.Result_Mode > 0) { ;Result Linear Array Filtered
				Output:=Array()
				For k,FKey in F_Inst.FArr.FK_Arr
					if(FKey.eval_result)
						Output.push(Options.Result_Mode == 1?FKey:Options.Result_Mode == 2?FKey.Key_Value[FKey.Key_Value.Length()]Key:FKey.Key_Value[FKey.Key_Value.Length()]Value)
				Arr[i]:=Output
			}
			else	{ ;Result Associative Array Filtered
				Output:=Array()
				For k,FKey in F_Inst.FArr.FK_Arr
					if(FKey.eval_result)
						Output[k]:=Options.Result_Mode == -1?FKey:FKey.Key_Value[FKey.Key_Value.Length()]Value
				if(Options.Result_Mode == -2)
					F_Inst.FArr.FK_Arr:=Output,Arr[i]:=F_Inst.FArr
				else
					Arr[i]:=Output
			}
		}
		return Options.Result_Mode == -4?Options:this.Generic.Helper.Return_Format(Arr)
	}
	F_Options(Filter_Options,Overwrite_Options:="") {
		If(isobject(Filter_Options))	{
			if(!this.isFilter(Filter_Options.Filter)){
				if(this.isFilter(Filter_Options))
					Filter_Options:={Filter:Filter_Options}
				else
					return
			}
			Options:=this.F_Template_Merge({FKey:"",FArr:"",FTemplate:""},this.F_Template_Filter(Filter_Options.Filter,Filter_Options,"Options_Template",Filter_Options))	;Merges Filter class Options into Options
			return isobject(Overwrite_Options)?this.F_Template_Merge(Overwrite_Options,Options):Options
		}
	}
	F_Eval(Filter, byref F_Inst,funct:="") {
		return this.F_Eval_Call(Filter,F_Inst,funct == "" or !isfunc(Filter[funct])?"Filter",funct)
	}
	F_Eval_Call(Filter, byref F_Inst,funct) {
		if(F_Inst.Eval_History == 1 or funct in F_Inst.Eval_History) {
			Hist_Obj:=this.F_Instance(F_Inst.FTemplate.FKey,F_Inst.FKey) ;Creates new Filter Key Instance Filter Key
			Hist_Obj.Filter:=Filter
			if(isobject(F_Inst.FKey.Eval_History)) ;Makes Eval_History Object
				F_Inst.FKey.Eval_History:={funct:Array()}
			if(isobject(F_Inst.FKey.Eval_History[funct]))
				F_Inst.FKey.Eval_History[funct].InsertAt(1,Hist_Obj)
			else
				F_Inst.FKey.Eval_History[funct]:=[Hist_Obj]
		}
		Hist_Obj.result:=result:=Filter[funct](F_Inst)
		return result
	}
	F_Template_Filter(Filter,Options,Template_Function,Master_Template) {
		f_func_param:=isfunc(Filter[funct])
		if(f_func_param != 1 and f_func_param != 2)
			return Master_Template
		filter_template:=f_func_param == 2? Filter[Template_Function](Options):Filter[Template_Function]() ;Calls Filter Template function to get Filter's Template
		return isobject(filter_template)?this.F_Template_Merge(Master_Template,filter_template):Master_Template
	}
	F_Template_Merge(Master_Template, Inherit_Template) {
		For k,v in Inherit_Template 
			if(!Master_Template.hasKey(k))
				Master_Template[k]:=v
		return Master_Template
	}
	F_Template(Options,Template_Function,Master_Template)	{
		Master_Template:=this.F_Template_Filter(Options.Filter,Options,Template_Function,Master_Template) ;Merges Options onto Master_Template then Merges Filter Template onto Master_Template
		subObjs:=Array()
		For k,v in Master_Template	;Checks for Sub Objects in Master_Template
			if(isobject(v))
				SubObjs.push(k)
		return {subo:SubObjs,template:Master_Template}
	}
	F_Instance(Template,Instance:="")	{
		Instance:=isobject(Instance)?this.F_Template_Merge(Instance,Template.template.Clone()):Template.template.Clone() ;Clones Master_Template
		For i,k in Template.subo			;Clones Sub Objects
			Instance[k]:=Instance[k].clone()
		Return Instance
	}
	isFilter(Filter:="",mode:=1)	{
		static Filter_Interface:=Lib.obj.class.interface({Filter:{Description:"Tests whether value should not be filtered out",MinParamsPlus1:2}})
		return mode?Filter_Interface.isImplemented(Filter):Filter_Interface
	}
	
	;Filter Templates
	Class Template extends Lib.Obj.Array.Filter {
		Call(Self,params*) {
			if(isobject(self))
				return new this(params*)
		}
		Filter(F_Inst) {
			return 0
		}
	}
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

	#Include %A_Scriptdir%\Library\Object\Array\Filter\Logic.ahk
	#Include %A_Scriptdir%\Library\Object\Array\Filter\Reference.ahk
	#Include %A_Scriptdir%\Library\Object\Array\Filter\Comparison.ahk


	


	;Miscellaneous Filters
	Class isMeta extends Lib.Obj.Array.Filter.Template {
		__New(Depth:=-1)	{
			this.Depth:=depth is digit and depth != "" and depth > 0? depth:-1
		}
		Filter(F_Inst) {
			if(this.depth == -1) {
				For i,kv in F_Inst.Key_Value
					if(Lib.obj.isMetaInfo(kv.Key,kv.Value))
						return 1
			}
			else {
				Loop %depth%
					if(Lib.obj.isMetaInfo(F_Inst.Key_Value[A_Index]Key,F_Inst.Key_Value[A_Index]Value))
						return 1
			}
			return 0
		}
	}
}