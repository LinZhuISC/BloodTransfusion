/// 
Class BloodTransfusion.Process.ServiceRequestHandlingProcess Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='BloodTransfusion.Message.ServiceRequest' response='HIP.Message.HIPRESTResponse' height='3400' width='2690' >
<context>
<property name='patInstance' type='ODS.Patient' instantiate='0' />
<property name='entInstance' type='ODS.Encounter' instantiate='0' />
<property name='srcReqInstance' type='ODS.BatchServiceRequest' instantiate='0' />
<property name='tmpFlag' type='%Boolean' instantiate='0' >
<annotation><![CDATA[Temp variable to use as a flag to indicate braches]]></annotation>
</property>
<property name='callResponse' type='HIP.Message.HIPRESTResponse' instantiate='0' />
<property name='tStream' type='%Stream.GlobalCharacter' instantiate='0' >
<annotation><![CDATA[Temporary steam object]]></annotation>
</property>
<property name='iter' type='%Integer' instantiate='0' />
<property name='batchObsInst' type='ODS.BatchObservation' instantiate='0' />
</context>
<sequence xend='200' yend='600' >
<switch name='What is the operation' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='"Create" = request.operation' name='Create a Service Request' >
<sequence name='CreateServiceRequest' xpos='335' ypos='400' xend='200' yend='2600' >
<call name='ReadPatient' target='ToHIP_REST接口' async='0' xpos='200' ypos='250' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Patient&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Read&quot;" action="set" />
<assign property="callrequest.Id" value="request.batchServiceRequest.Patient.ResourceId" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Patient exists' condition='(("200" = context.callResponse.Code) &amp;&amp; ("" &apos;= context.callResponse.Payload))' xpos='200' ypos='350' xend='200' yend='600' >
<true>
<assign name="set Successful flag" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='500' />
</true>
<false>
<sequence name='SavePatient' xpos='200' ypos='500' xend='200' yend='800' >
<code name='GetPatientStream' xpos='200' ypos='250' >
<![CDATA[ Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stm,request.batchServiceRequest.Patient,,,1,"s")
 Set context.tStream=##class(%GlobalCharacterStream).%New()
 Do context.tStream.CopyFrom(stm)
 ]]>
</code>
<call name='SavePatientToODS' target='ToHIP_REST接口' async='0' xpos='200' ypos='350' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Patient&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Create&quot;" action="set" />
<assign property="callrequest.Payload" value="context.tStream" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='Save Patient Succeed?' condition='"200" = context.callResponse.Code' xpos='200' ypos='450' xend='200' yend='700' >
<true>
<assign name="Set Successful flag" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='600' />
</true>
<false>
<assign name="Set Failure flag" property="context.tmpFlag" value="0" action="set" xpos='200' ypos='600' />
</false>
</if>
</sequence>
</false>
</if>
<if name='Save Patient Succeed?' condition='context.tmpFlag' xpos='200' ypos='700' xend='200' yend='2500' >
<true>
<code name='Save Patient in context' xpos='470' ypos='850' >
<![CDATA[ set inst = ""
 do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(context.callResponse.Payload,"ODS.Patient",.inst,1)
 set context.patInstance  = inst]]>
</code>
<call name='ReadEncounter' target='ToHIP_REST接口' async='0' xpos='470' ypos='950' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Encounter&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Read&quot;" action="set" />
<assign property="callrequest.Id" value="request.batchServiceRequest.Encounter.ResourceId" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Encounter Exists' condition='(("200" = context.callResponse.Code) &amp;&amp; ("" &apos;= context.callResponse.Payload))' xpos='470' ypos='1050' xend='470' yend='1300' >
<true>
<assign name="set Successful flag" property="context.tmpFlag" value="1" action="set" xpos='740' ypos='1200' />
</true>
<false>
<sequence name='SaveEncounter' xpos='470' ypos='1200' xend='200' yend='800' >
<code name='GetEncounterStream' xpos='200' ypos='250' >
<![CDATA[ set ent = request.batchServiceRequest.Encounter
 set ent.Subject = context.patInstance
 Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stm,ent,,,1,"s")
 Set context.tStream=##class(%GlobalCharacterStream).%New()
 Do context.tStream.CopyFrom(stm)
 ]]>
</code>
<call name='SaveEncounterToODS' target='ToHIP_REST接口' async='0' xpos='200' ypos='350' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Encounter&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Create&quot;" action="set" />
<assign property="callrequest.Payload" value="context.tStream" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Save Encounter Succeed' condition='"200" = context.callResponse.Code' xpos='200' ypos='450' xend='200' yend='700' >
<true>
<assign name="set flag as 1" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='600' />
</true>
<false>
<assign name="set flag as 0" property="context.tmpFlag" value="0" action="set" xpos='200' ypos='600' />
</false>
</if>
</sequence>
</false>
</if>
<if name='Save Encounter Succeed?' condition='context.tmpFlag' xpos='470' ypos='1400' xend='470' yend='2400' >
<true>
<code name='Save Encounter in context' xpos='740' ypos='1550' >
<![CDATA[ set inst = ""
 do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(context.callResponse.Payload,"ODS.Encounter",.inst,1)
 set context.entInstance  = inst]]>
</code>
<assign name="ClearIterationIdex" property="context.iter" value="1" action="set" xpos='740' ypos='1650' />
<foreach name='IterateDiagnosis' property='request.diagnoses' key='context.iter' xpos='740' ypos='1750' xend='200' yend='450' >
<code name='GetDiagnosisStream' xpos='200' ypos='250' >
<![CDATA[ set stm = ""
 Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stm,request.diagnoses.GetAt(context.iter),,,1,"s")
 Set context.tStream=##class(%GlobalCharacterStream).%New()
 Do context.tStream.CopyFrom(stm)
 ]]>
</code>
<call name='SaveDiagnosisToODS' target='ToHIP_REST接口' async='1' xpos='200' ypos='350' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Diagnosis&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Create&quot;" action="set" />
<assign property="callrequest.Payload" value="context.tStream" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
</foreach>
<sequence name='BatchSaveObservation' xpos='740' ypos='1850' xend='200' yend='1100' >
<assign name="GetBatchObservation" property="context.batchObsInst" value="request.batchObservation" action="set" xpos='200' ypos='250' />
<assign name="ClearInstEncounter" property="context.batchObsInst.Encounter" value="&quot;&quot;" action="set" xpos='200' ypos='350' />
<assign name="SetEncounterResourceId" property="context.batchObsInst.Encounter.ResourceId" value="context.entInstance.ResourceId" action="set" xpos='200' ypos='450' />
<code name='GetInstStream' xpos='200' ypos='550' >
<![CDATA[ set inst = context.batchObsInst
 Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stm,inst,,,1,"s")
 Set context.tStream=##class(%GlobalCharacterStream).%New()
 Do context.tStream.CopyFrom(stm)
 ]]>
</code>
<call name='SaveObsToODS' target='ToHIP_REST接口' async='0' xpos='200' ypos='650' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;BatchObservation&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Create&quot;" action="set" />
<assign property="callrequest.Payload" value="context.tStream" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Batch Save Succeed?' condition='"200" = context.callResponse.Code' xpos='200' ypos='750' xend='200' yend='1000' >
<true>
<assign name="set flag as 1" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='900' />
</true>
<false>
<assign name="set flag as 0" property="context.tmpFlag" value="0" action="set" xpos='200' ypos='900' />
</false>
</if>
</sequence>
<sequence name='BatchSaveServiceRequest' xpos='740' ypos='1950' xend='200' yend='1300' >
<assign name="GetBatchServiceRequest" property="context.srcReqInstance" value="request.batchServiceRequest" action="set" xpos='200' ypos='250' />
<assign name="ClearReqPatient" property="context.srcReqInstance.Patient" value="&quot;&quot;" action="set" xpos='200' ypos='350' />
<assign name="ClearReqEncounter" property="context.srcReqInstance.Encounter" value="&quot;&quot;" action="set" xpos='200' ypos='450' />
<assign name="SetPatientResourceId" property="context.srcReqInstance.Patient.ResourceId" value="context.patInstance.ResourceId" action="set" xpos='200' ypos='550' />
<assign name="SetEncounterResourceId" property="context.srcReqInstance.Encounter.ResourceId" value="context.entInstance.ResourceId" action="set" xpos='200' ypos='650' />
<code name='GetRequestStream' xpos='200' ypos='750' >
<![CDATA[ set req = context.srcReqInstance
 Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stm,req,,,1,"s")
 Set context.tStream=##class(%GlobalCharacterStream).%New()
 Do context.tStream.CopyFrom(stm)
 ]]>
</code>
<call name='SaveServiceRequestsToODS' target='ToHIP_REST接口' async='0' xpos='200' ypos='850' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;BatchServiceRequest&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Create&quot;" action="set" />
<assign property="callrequest.Payload" value="context.tStream" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Batch Save Succeed?' condition='"200" = context.callResponse.Code' xpos='200' ypos='950' xend='200' yend='1200' >
<true>
<assign name="set flag as 1" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='1100' />
</true>
<false>
<assign name="set flag as 0" property="context.tmpFlag" value="0" action="set" xpos='200' ypos='1100' />
</false>
</if>
</sequence>
<if name='Save Batch Request Succeed?' condition='context.tmpFlag' xpos='740' ypos='2050' xend='740' yend='2300' >
<false>
<trace name='Get BatchRequest Failure SubProcess' value='"TODO: Get BatchRequest Failure SubProcess"' xpos='875' ypos='2200' />
</false>
</if>
</true>
<false>
<trace name='Get Encounter Failure SubProcess' value='"TODO: Get Encounter Failure SubProcess"' xpos='470' ypos='1550' />
</false>
</if>
</true>
<false>
<trace name='Get Patient Failure SubProcess' value='"TODO: Get Patient Failure SubProcess"' xpos='200' ypos='850' />
</false>
</if>
</sequence>
</case>
<case condition='"Update" = request.operation' name='Update A Service Request' >
<sequence name='UpdateServiceRequest' xpos='605' ypos='400' xend='200' yend='2300' >
<call name='GetPatient' target='ToHIP_REST接口' async='0' xpos='200' ypos='250' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Patient&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Read&quot;" action="set" />
<assign property="callrequest.Id" value="request.batchServiceRequest.Patient.ResourceId" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Patient exists' condition='(("200" = context.callResponse.Code) &amp;&amp; ("" &apos;= context.callResponse.Payload))' xpos='200' ypos='350' xend='200' yend='600' >
<true>
<assign name="set Successful flag" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='500' />
</true>
<false>
<assign name="set Failure flag" property="context.tmpFlag" value="0" action="set" xpos='200' ypos='500' />
</false>
</if>
<if name='Get Patient Succeed?' condition='context.tmpFlag' xpos='200' ypos='700' xend='200' yend='2200' >
<true>
<code name='Save Patient in context' xpos='470' ypos='850' >
<![CDATA[ set inst = ""
 do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(context.callResponse.Payload,"ODS.Patient",.inst,1)
 set context.patInstance  = inst]]>
</code>
<call name='GetEncounter' target='ToHIP_REST接口' async='0' xpos='470' ypos='950' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;Encounter&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Read&quot;" action="set" />
<assign property="callrequest.Id" value="request.batchServiceRequest.Encounter.ResourceId" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Encounter Exists' condition='(("200" = context.callResponse.Code) &amp;&amp; ("" &apos;= context.callResponse.Payload))' xpos='470' ypos='1050' xend='470' yend='1300' >
<true>
<assign name="set Successful flag" property="context.tmpFlag" value="1" action="set" xpos='740' ypos='1200' />
</true>
<false>
<assign name="set Failure flag" property="context.tmpFlag" value="0" action="set" xpos='470' ypos='1200' />
</false>
</if>
<if name='Get Encounter Succeed?' condition='context.tmpFlag' xpos='470' ypos='1400' xend='470' yend='2100' >
<true>
<code name='Save Encounter in context' xpos='740' ypos='1550' >
<![CDATA[ set inst = ""
 do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(context.callResponse.Payload,"ODS.Encounter",.inst,1)
 set context.entInstance  = inst]]>
</code>
<sequence name='BatchUpdateServiceRequest' xpos='740' ypos='1650' xend='200' yend='1300' >
<assign name="GetBatchServiceRequest" property="context.srcReqInstance" value="request.batchServiceRequest" action="set" xpos='200' ypos='250' />
<assign name="ClearReqPatient" property="context.srcReqInstance.Patient" value="&quot;&quot;" action="set" xpos='200' ypos='350' />
<assign name="ClearReqEncounter" property="context.srcReqInstance.Encounter" value="&quot;&quot;" action="set" xpos='200' ypos='450' />
<assign name="SetPatientResourceId" property="context.srcReqInstance.Patient.ResourceId" value="context.patInstance.ResourceId" action="set" xpos='200' ypos='550' />
<assign name="SetEncounterResourceId" property="context.srcReqInstance.Encounter.ResourceId" value="context.entInstance.ResourceId" action="set" xpos='200' ypos='650' />
<code name='GetRequestStream' xpos='200' ypos='750' >
<![CDATA[ set req = context.srcReqInstance
 Do ##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stm,req,,,1,"s")
 Set context.tStream=##class(%GlobalCharacterStream).%New()
 Do context.tStream.CopyFrom(stm)
 ]]>
</code>
<call name='UpdateServiceRequestsToODS' target='ToHIP_REST接口' async='0' xpos='200' ypos='850' >
<request type='HIP.Message.HIPRESTRequest' >
<assign property="callrequest.Type" value="&quot;BatchServiceRequest&quot;" action="set" />
<assign property="callrequest.Operation" value="&quot;Update&quot;" action="set" />
<assign property="callrequest.Payload" value="context.tStream" action="set" />
<assign property="callrequest.Id" value="context.srcReqInstance.ServiceRequests.GetAt(1).ResourceId" action="set" />
</request>
<response type='HIP.Message.HIPRESTResponse' >
<assign property="context.callResponse" value="callresponse" action="set" />
</response>
</call>
<if name='If Batch Update Succeed?' condition='"200" = context.callResponse.Code' xpos='200' ypos='950' xend='200' yend='1200' >
<true>
<assign name="set flag as 1" property="context.tmpFlag" value="1" action="set" xpos='470' ypos='1100' />
</true>
<false>
<assign name="set flag as 0" property="context.tmpFlag" value="0" action="set" xpos='200' ypos='1100' />
</false>
</if>
</sequence>
<if name='Update Batch Request Succeed?' condition='context.tmpFlag' xpos='740' ypos='1750' xend='740' yend='2000' >
<false>
<trace name='Get BatchRequest Failure SubProcess' value='"TODO: Get BatchRequest Failure SubProcess"' xpos='875' ypos='1900' />
</false>
</if>
</true>
<false>
<trace name='Get Encounter Failure SubProcess' value='"TODO: Get Encounter Failure SubProcess"' xpos='470' ypos='1550' />
</false>
</if>
</true>
<false>
<trace name='Get Patient Failure SubProcess' value='"TODO: Get Patient Failure SubProcess"' xpos='200' ypos='850' />
</false>
</if>
</sequence>
</case>
<default name='default' />
</switch>
</sequence>
</process>
}

}
