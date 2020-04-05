<template>
    <Tabs type="card">
        <TabPane label="订单">
            <Form :model="orderData" :label-width="100" inline>
                <Row>
                    <iCol span="12">
                        <FormItem label="订单编号" prop="order_no">
                            <Input v-model="orderData.order_no" disabled style="width:200px" ></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="名称" prop="name">
                            <Input v-model="orderData.name" disabled style="width:200px" ></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="型号" prop="pro_type">
                            <Input v-model="orderData.pro_type" disabled style="width:200px" ></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="数量" prop="pro_num">
                            <Input  style="width:200px"  :value="orderData.pro_num ? orderData.pro_num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : ''"  disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="价格" prop="pro_price">
                            <Input  style="width:200px"  :value="orderData.pro_price ? orderData.pro_price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : ''"  disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="含税" prop="with_tax">
                            <Input   style="width:200px" :value="orderData.with_tax=='1' ? '是':'否'"  disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="开票日期" prop="invoice_date">
                            <Input style="width:200px"   :value="formatDate(orderData.invoice_date,'yyyy-MM-dd')"  disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="材质" prop="pro_material">
                            <Input style="width:200px"  v-model="orderData.pro_material" disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="原料厂家" prop="material_source">
                            <Input style="width:200px"  v-model="orderData.material_source" disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="客户联系人" prop="custom">
                            <Input  style="width:200px"  :value="convertDict('custom',orderData.custom)"  disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="预计交期" prop="plan_date">
                            <Input  style="width:200px"  :value="formatDate(orderData.plan_date,'yyyy-MM-dd')"  disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">  <!--order_status-->
                        <FormItem label="状态" prop="status">
                            <Input  style="width:200px"  :value="convertDict('order_status',orderData.status)"  disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12"> <!--pay_type-->
                        <FormItem label="付款方式" prop="pay_type">
                            <Input  style="width:200px"  :value="convertDict('pay_type',orderData.pay_type)"  disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12"> <!--pay_status-->
                        <FormItem label="付款状态" prop="pay_status">
                            <Input   style="width:200px" :value="convertDict('pay_status',orderData.pay_status)"  disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="24">
                        <FormItem label="备注" prop="remark">
                            <Input  style="width:400px" v-model="orderData.remark" type="textarea" disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>

            </Form>
        </TabPane>
        <TabPane label="流程">
            <div style="max-height: 450px;overflow:auto">
                <Alert type="warning"  v-if="nowStep == 1111"  show-icon>
                    订单还没有开始生产
                </Alert>
                <Steps :current="nowStep" v-if="nowStep < 1111" direction="vertical">
                    <Step  v-for="(item,index) in stepList" :title="convertDict('order_process_type',item.status)"   :key = "`${_uid}_${index}`" :content="'环节：' + item.s_step_name +  (item.finish_date? '  ，完成时间：'+item.finish_date:'')"></Step>
                </Steps>
            </div>
        </TabPane>
        <TabPane label="环节">
            <Alert type="warning"  v-if="nowStep == 1111"  show-icon>
                订单还没有开始生产
            </Alert>

            <Alert type="success"  v-if="nowStep == 999"  show-icon>
                订单已经完成生产
                <span slot="desc">完成时间 ：{{orderData.finish_date}} </span>
            </Alert>
            <Form ref="formRef" v-if="nowStep < 999" :model="stepForm" :rules="ruleValidate" :label-width="80" inline>
                <Row>
                    <iCol span="12">
                        <FormItem label="环节名称" prop="step_name">
                            <Input v-model="stepForm.s_step_name" disabled="" style="width:200px"></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="预计时间" prop="plan_date">
                            <DatePicker type="datetime" format="yyyy-MM-dd HH:mm"  v-model="stepForm.plan_date" style="width: 200px"
                                        @on-change="stepForm.plan_date=$event"  ></DatePicker>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="经手人" prop="user_name">
                            <Input v-model="stepForm.user_name" style="width:200px" disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="数量" prop="pro_num">
                            <InputNumber style="width: 200px"
                                         v-model="stepForm.pro_num"
                                         :formatter="value => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')"
                                         :parser="value => value.replace(/\$\s?|(,*)/g, '')"></InputNumber>
                        </FormItem>
                    </iCol>
                </Row>

                <my-form-group :list="stepItems" ></my-form-group>

                <Row>
                    <iCol span="12">
                        <FormItem label="完成时间" prop="finish_date">
                            <Input v-model="stepForm.finish_date" style="width:200px"  disabled></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="状态" prop="status">
                            <Input  :value="convertDict('order_process_type',stepForm.status)" style="width:200px" disabled></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                        <FormItem label="备注" prop="remarks">
                            <Input v-model="stepForm.remarks"  type="textarea" style="width:400px"></Input>
                        </FormItem>
                    </iCol>
                </Row>
            </Form>
        </TabPane>
        <TabPane label="办理历史">
            <div style="max-height: 450px;overflow:auto">
                <Alert type="warning"  v-if="nowStep == 1111"  show-icon>
                    订单还没有开始生产
                </Alert>

                <Alert type="warning" v-if="nowStep <= 0" show-icon> 暂无办理历史记录</Alert>

                <Collapse v-if="nowStep > 0 && nowStep < 1111">
                    <Panel  v-for="(item,index) in stepList"  v-if="item.status == '2'" :name="`${index}`" :key = "`${_uid}_${index}`" >
                        {{item.s_step_name}} &nbsp;&nbsp;<Icon type="ios-arrow-forward" />&nbsp;&nbsp; {{item.user_name}}  &nbsp;&nbsp;<Icon type="ios-arrow-forward" /> &nbsp;&nbsp;{{item.finish_date}}
                        <p slot="content">
                            <Row>
                                <iCol span="24">
                                    <iCol span="3" align="right">环节名称：</iCol>   <iCol >{{item.s_step_name}}</iCol>
                                </iCol>
                                <iCol span="24">
                                    <iCol span="3" align="right">经手人：</iCol>   <iCol>{{item.user_name}}</iCol>
                                </iCol>
                                <iCol span="24">
                                    <iCol span="3" align="right">完成时间：</iCol>   <iCol>{{item.finish_date}}</iCol>
                                </iCol>
                                <iCol span="24">
                                    <iCol span="3" align="right">数量：</iCol>   <iCol>{{item.pro_num}}</iCol>
                                </iCol>
                                <my-form-group-read :list="item.items" ></my-form-group-read>
                                <iCol span="24">
                                    <iCol span="3" align="right">备注：</iCol>   <iCol>{{item.remarks}}</iCol>
                                </iCol>
                            </Row>
                        </p>
                    </Panel>
                </Collapse>
            </div>
        </TabPane>
    </Tabs>
</template>
<script>
    import util from '@/libs/util.js';
    import myFormGroup from '@/views/my/my-form-group.vue';
    import myFormGroupRead from '@/views/my/my-form-group-read.vue';
    export default {
        name: "orderDetailRead",
        components: {
            myFormGroup,
            myFormGroupRead
        },
        props:{
            order_id:{
                type:String,
                default:()=>{}
            }
        },
        data () {
            return {
                status_dict:{},
                nowStep:-1,
                stepItems:[],
                stepForm: {
                },
                orderData: {
                },
                stepList: [],
                ruleValidate: {
                }
            }

        },
        methods: {
            init () {
                this.nowStep = -1;
                this.stepForm = {};
                this.stepItems= [];

                if(this.order_id){
                    let _self=this;
                    //所有环节数据  & 订单数据
                    util.post(this,'biz/biz_order/processInfo',{id:this.order_id},function(datas){
                        _self.orderData = datas.order;
                        _self.stepList = datas.list;

                        for(let _s of datas.list ){
                            if(_s.process_status == '1'){
                                _self.nowStep=_s.sort_no-1;
                                _self.stepForm = _s;
                                _self.stepItems=_s.items;
                                break;
                            }
                        }
                        if( _self.nowStep == -1){
                            _self.nowStep=999;
                            _self.stepForm = {};
                            _self.stepItems= [];
                        }
                        if(datas.list.length == 0){
                            _self.nowStep=1111;
                            _self.stepForm = {};
                            _self.stepItems= [];
                        }

                        _self.stepForm.pro_num= _self.stepForm.pro_num ? Number.parseInt( _self.stepForm.pro_num) : null;
                        _self.stepForm.plan_date = _self.stepForm.plan_date ? new Date(_self.stepForm.plan_date) : null;
                        console.log(datas)
                    });
                }

            },
            formatDate(date,p){
                return !date? '': util.formatDate(new Date(date), p);
            },
            convertDict(type,value){
                return util.showDictLabel(type,value);
            },
        },
        mounted () {
            this.status_dict=util.showDictList('order_process_type');
            this.init();
        },

        watch: {
            order_id: {
                handler () {
                    this.init();
                },
                deep: true,
                immediate: true,
            }
        }
    }
</script>
