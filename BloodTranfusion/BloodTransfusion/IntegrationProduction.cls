Class BloodTransfusion.IntegrationProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="BloodTransfusion.IntegrationProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HISV251Tcp服务" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">输血V2业务流程</Setting>
    <Setting Target="Adapter" Name="Port">50001</Setting>
    <Setting Target="Host" Name="DefCharEncoding">utf-8</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication">WISU:HIP</Setting>
    <Setting Target="Host" Name="AckMode">App</Setting>
  </Item>
  <Item Name="ToHIP_REST接口" Category="" ClassName="BloodTransfusion.BO.RESTToHIPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">57772</Setting>
    <Setting Target="Adapter" Name="HTTPServer">192.168.113.190</Setting>
    <Setting Target="Adapter" Name="URL">/HIP/REST</Setting>
  </Item>
  <Item Name="输血V2业务流程" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">BloodTransfusion.Rule.BloodTransfusionV2HandlingRule</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication">WISU:HIP</Setting>
    <Setting Target="Host" Name="AckType">Commit</Setting>
    <Setting Target="Host" Name="AddNackERR">1</Setting>
    <Setting Target="Host" Name="AlertOnBadMessage">1</Setting>
  </Item>
  <Item Name="输血申请处理流程" Category="" ClassName="BloodTransfusion.Process.ServiceRequestHandlingProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="RuleLogging">a</Setting>
  </Item>
  <Item Name="ToHIS_HL7文件接口" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Charset">Native</Setting>
    <Setting Target="Host" Name="DefCharEncoding">utf-8</Setting>
    <Setting Target="Host" Name="SearchTableClass">EnsLib.HL7.SearchTable</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\Demo\HIS\HL7V2\</Setting>
    <Setting Target="Host" Name="Framing">MLLP</Setting>
  </Item>
  <Item Name="To输血系统_HL7文件接口" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIS订阅接口流程" Category="" ClassName="BloodTransfusion.Process.HISSubscriber" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="BloodTransfusion.BS.HISService" Category="" ClassName="BloodTransfusion.BS.HISService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
