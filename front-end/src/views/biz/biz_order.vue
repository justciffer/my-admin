<style lang="less">
     .table-min-width{
        min-width:120px;
        width:120px
    }
     .line-box{
         display: flex;
         justify-content: space-between;
         align-items: center;
         margin: 40px auto;
     }
     .text{
         min-width: 120px;
         font-size: 14px;
         text-align: center;
     }
     .line{
         width: 40%;
         height: 1px;
         background-color: #ccc;
     }
</style>
<template>
     <div>
        <Row>
            <iCol span="24">
                <Card>
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        业务订单列表
                    </p>
                    <Row>
                        订单编号：<Input v-model="searchForm.order_no" placeholder="请输入要搜索的订单编号" style="width: 200px;margin-right: 20px;" />
                        订单状态：   <Select style="width:200px" v-model="searchForm.status" >
                                        <Option v-for="item in order_status_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                                    </Select>
                        <span @click="handleSearch"><Button type="primary" icon="search">搜索</Button></span>
                    </Row>
                    <Row style="margin-top:10px;">
                        <Button type="info" @click="add">添加</Button>
                    </Row>
                    <Row type="flex" justify="center" align="middle" class="advanced-router">
                        <Table border stripe :columns="columns" :data="data" :loading="loading" style="width: 100%;margin-top:10px"></Table>
                        <Page :total="count" :current="searchForm.current" show-total  style="margin-top:10px;" @on-change="pageChange"></Page>
                    </Row>
                </Card>
            </iCol>
        </Row>
        <Modal  title="编辑"  :mask-closable="false" :closable="false" v-model="modalAdd" width="700">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="100" >
                <Row>
                    <iCol span="12">
                        <FormItem label="订单编号" prop="order_no">
                            <Input v-model="formValidate.order_no"></Input>
                        </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="名称" prop="name">
                            <Input v-model="formValidate.name"></Input>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                    <FormItem label="型号" prop="pro_type">
                        <Input v-model="formValidate.pro_type"></Input>
                    </FormItem>
                    </iCol>
                    <iCol span="12">
                        <FormItem label="数量" prop="pro_num">
                            <InputNumber style="width: 200px"
                                         v-model="formValidate.pro_num"
                                         :formatter="value => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')"
                                         :parser="value => value.replace(/\$\s?|(,*)/g, '')"></InputNumber>
                        </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                    <FormItem label="价格" prop="pro_price">
                        <InputNumber style="width: 200px"
                                v-model="formValidate.pro_price"
                                :formatter="value => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')"
                                :parser="value => value.replace(/\$\s?|(,*)/g, '')"></InputNumber>
                    </FormItem>
                    </iCol>
                    <iCol span="12">
                    <FormItem label="含税" prop="with_tax">
                        <i-switch  v-model="formValidate.with_tax"  true-value="1" false-value="0" >
                            <span slot="open">是</span>
                            <span slot="close">否</span>
                        </i-switch>
                    </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                    <FormItem label="开票日期" prop="invoice_date">
                        <DatePicker type="date" v-model="formValidate.invoice_date"
                                    @on-change="(datetime) =>{ formValidate.invoice_date = datetime;}">
                        </DatePicker>
                    </FormItem>
                    </iCol>
                    <iCol span="12">
                    <FormItem label="材质" prop="pro_material">
                        <Input v-model="formValidate.pro_material"></Input>
                    </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                    <FormItem label="原料厂家" prop="material_source">
                        <Input v-model="formValidate.material_source"></Input>
                    </FormItem>
                    </iCol>
                    <iCol span="12">
                    <FormItem label="客户联系人" prop="custom">
                        <Select style="width:200px" v-model="formValidate.custom" >
                            <Option v-for="item in custom_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                        </Select>
                    </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12">
                    <FormItem label="预计交期" prop="plan_date">
                        <DatePicker type="date" v-model="formValidate.plan_date"
                                    @on-change="(datetime) =>{ formValidate.plan_date = datetime;}">
                        </DatePicker>
                    </FormItem>
                    </iCol>
                    <iCol span="12">  <!--order_status-->
                    <FormItem label="状态" prop="status">
                        <Select style="width:200px" v-model="formValidate.status" >
                            <Option v-for="item in order_status_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                        </Select>
                    </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="12"> <!--pay_type-->
                    <FormItem label="付款方式" prop="pay_type">
                        <Select style="width:200px" v-model="formValidate.pay_type" >
                            <Option v-for="item in pay_type_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                        </Select>
                    </FormItem>
                    </iCol>
                    <iCol span="12"> <!--pay_status-->
                    <FormItem label="付款状态" prop="pay_status">
                        <Select style="width:200px" v-model="formValidate.pay_status" >
                            <Option v-for="item in pay_status_dict"  :value="item.value" :key="item.value" >{{ item.label }}</Option>
                        </Select>
                    </FormItem>
                    </iCol>
                </Row>
                <Row>
                    <iCol span="24">
                    <FormItem label="备注" prop="remark">
                       <Input v-model="formValidate.remark" type="textarea"></Input>
                    </FormItem>
                    </iCol>
                </Row>
            </Form>
            <div slot="footer">
                <Button type="text" @click="addCanFun" v-show="modalCanBut">取消</Button>
                <Button type="primary" @click="addOkFun" :loading="modalLoading">确定</Button>
            </div>
        </Modal>

        <Modal  title="详情" v-model="modalDetail" scrollable  width="850">
            <order-detail-read :order_id="detailId"></order-detail-read>
            <div slot="footer">
            </div>
        </Modal>

         <Modal  title="定制流程 (已经开始生产的订单会被重置)"  :mask-closable="false" :closable="false" v-model="showStartOrder" width="700" >
             <Form ref="formRef_start" :model="startOrderForm" :rules="startOrderFormRules" :label-width="200">
                 <FormItem label="订单编号" prop="order_no">
                     <Input v-model="startOrderForm.order_no" readonly="" style="width:200px"></Input>
                 </FormItem>
                 <FormItem label="订单名称" prop="order_name">
                     <Input v-model="startOrderForm.order_name" readonly="" style="width:200px"></Input>
                 </FormItem>
                 <FormItem label="流程模板" prop="process_id">
                     <Select style="width:200px" v-model="startOrderForm.process_id" @on-change="showStep" >
                         <Option v-for="item in process_list"  :value="item.id" :key="item.id" >{{ item.name + (item.remarks?" -- "+item.remarks:'')}}</Option>
                     </Select>
                 </FormItem>
                 <div class="line-box">
                     <span class="line"></span><span class="text">流程初始化</span><span class="line"></span>
                 </div>
                 <!--todo: 动态表单-->
                 <my-form-group :list="stepDefFormItems" ></my-form-group>

             </Form>
             <div slot="footer">
                 <Button type="text" @click="startOrderCanFun" v-show="modalCanBut">取消</Button>
                 <Button type="primary" @click="startOrderOkFun" :loading="modalLoading">确定</Button>
             </div>
         </Modal>
    </div>
</template>
<script>
    import util from '@/libs/util.js';
    import myFormGroup from '@/views/my/my-form-group.vue';
    import orderDetailRead from '@/views/biz/order_detail_read.vue';

    export default {
        components: {
            myFormGroup,
            orderDetailRead
        },
        data () {
            return {
                detailId:'',
                modalAdd:false,
                modalDetail:false,
                showStartOrder:false,
                stepDefFormItems:[],
                stepList:[],
                startOrderForm:{},
                loading:false,
                modalLoading:false,
                modalCanBut:true,
                order_status_dict:{},
                pay_status_dict:{},
                custom_dict:{},
                pay_type_dict:{},
                process_list:{},
                searchForm:{
                    current:1
                },
                data: [],
                //todo: 默认值的原因
                formValidate: {
                    with_tax:'0'
                },
                count:0,
                columns: [
                    {
                        title: '订单编号',
                        key: 'order_no',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '订单名称',
                        key: 'name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '产品数量',
                        key: 'pro_num',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '预计交期',
                        key: 'plan_date',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                        render: function (h, params) {
                            return h('span',
                                util.formatDate(new Date(params.row.plan_date), 'yyyy-MM-dd'))
                        }
                    },
                    {
                        title: '状态',
                        key: 'status',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                        render: (h, params) => {
                            return  h('span', util.showDictLabel('order_status',params.row.status));
                        }
                    },
                    {
                        title: '付款状态',
                        key: 'pay_status',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                        render: (h, params) => {
                            return  h('span', util.showDictLabel('pay_status',params.row.pay_status));
                        }
                    },
                    {
                        title: '操作',
                        key: 'action',
                        width: 230,
                        align: 'center',
                        render: (h, params) => {
                            return h('div', [
                                h('Button', {
                                    props: {
                                        type: 'warning',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: () => {
                                            this.startOrder(params);
                                        }
                                    }
                                }, '开始'),

                                h('Button', {
                                    props: {
                                        type: 'info',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: () => {
                                            this.show(params)
                                        }
                                    }
                                }, '查看'),
                                h('Button', {
                                    props: {
                                        type: 'success',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: () => {
                                            this.edit(params)
                                        }
                                    }
                                }, '编辑'),
                                h('Poptip', {
                                    props: {
                                        confirm: true,
                                        title: '您确定要删除这条数据吗?',
                                        transfer: true
                                    },
                                    on: {
                                        'on-ok': () => {
                                           this.remove(params);
                                        }
                                    }
                                }, [
                                    h('Button', {
                                        style: {
                                            marginRight: '5px'
                                        },
                                        props: {
                                            type: 'error',
                                            placement: 'top',
                                            size: 'small'
                                        }
                                    }, '删除')
                                ])
                            ]);
                        }
                    }
                ],
                startOrderFormRules:{
                    process_id: [
                        { required: true, message: '请选择流程模版'}
                    ],
                },
                ruleValidate: {
                    custom: [
                        { required: true, message: '客户联系人为必填项'}
                    ],
                    plan_date: [
                        { required: true, message: '预计交期为必填项'}
                    ],
                    invoice_date: [
                        { required: true, message: '开票时间为必填项'}
                    ],
                    material_source: [
                        { required: true, message: '原料厂家为必填项'}
                    ],
                    name: [
                        { required: true, message: '订单名称为必填项'}
                    ],
                    order_no: [
                        { required: true, message: '订单编号为必填项'}
                    ],
                    pay_status: [
                        { required: true, message: '付款状态为必填项'}
                    ],
                    pay_type: [
                        { required: true, message: '付款方式为必填项'}
                    ],
                    pro_material: [
                        { required: true, message: '产品材质为必填项'}
                    ],
                    pro_num: [
                        { required: true, message: '产品数量为必填项'}
                    ],
                    pro_price: [
                        { required: true, message: '产品价格为必填项'}
                    ],
                    pro_type: [
                        { required: true, message: '产品类型为必填项'}
                    ],
                    remark: [
                        { required: false, message: '备注为必填项'}
                    ],
                    status: [
                        { required: true, message: '状态为必填项'}
                    ],
                    with_tax: [
                        { required: true, message: '含税为必填项'}
                    ],
                }
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                util.post(this,'biz/biz_order/pageData',this.searchForm,function(datas){
                    _self.data=datas.data;
                    _self.count=datas.count;
                    _self.loading=false;
                });
            },
            handleSearch(){
                this.searchForm.current=1;
                this.init();
            },
            formatDate(date){
                return !date? '': util.formatDate(new Date(date), 'yyyy-MM-dd');
            },
            convertDict(type,value){
                return util.showDictLabel(type,value);
            },
            pageChange(current){
                this.searchForm.current=current;
                this.init();
            },

            startOrder (param) {
                this.startOrderForm = {};
                this.stepList=[];
                this.stepDefFormItems=[];
                this.startOrderForm.order_id = param.row.id;
                this.startOrderForm.order_no = param.row.order_no;
                this.startOrderForm.order_name = param.row.name;
                this.showStartOrder=true;

                let _self=this;
                //todo: process_list获取 模板 + 模板对应环节+默认值
                util.post(this,'biz/biz_process/allData',{},function(datas){
                    _self.process_list=datas;
                });
            },
            /**
             * 流程模版 -- 环节
             */
            showStep(process_id){
                this.stepList = [];
                this.stepDefFormItems = [];
                if(process_id){
                    let _self=this;
                    util.post(this,'biz/biz_process/processData',{process_id:process_id},function(datas){
                        if(datas && datas.step_list){
                            _self.stepList = datas.step_list;
                            _self.addStepItem( _self.stepList);
                        }
                    });
                }
            },
            /**
             * 流程模版 -- 环节 -- 默认值
             */
            addStepItem(stepList){
                stepList.forEach(item =>{
                    if(item.form_config){
                        let _config = JSON.parse(item.form_config);
                        if(_config && _config.length > 0){
                            item.itemList=_config;
                            _config.forEach(_c=>{
                                _c.origin_name =  _c.name;
                                _c.origin_key =  _c.key;

                                //默认值
                                if(_c.def == '1'){
                                    _c.name = item.name + " >> " + _c.name;
                                    _c.key = item.id + "#" + _c.key;
                                    this.stepDefFormItems.push(_c);
                                }
                            });
                        }
                    }
                });
            },
            startOrderOkFun () {
                this.startOrderForm.stepList=this.stepList;
                console.log( this.startOrderForm);
                let _self=this;
                this.$refs['formRef_start'].validate((valid) => {
                    if (valid) {
                        util.changeModalLoading(this,true);
                        let _data=util.copy(this.startOrderForm);
                        util.post(this,'biz/biz_order/start',_data,function(datas){
                            _self.$Message.success('启动订单！');
                            _self.showStartOrder=false;
                            util.changeModalLoading(_self);
                            _self.$refs['formRef_start'].resetFields();
                            _self.init();
                        });

                    }else{
                        util.changeModalLoading(this);
                    }
                })

            },
            startOrderCanFun () {
                this.showStartOrder=false;
                util.changeModalLoading(this);
                this.$refs['formRef_start'].resetFields();
            },

            add (){
                this.formValidate={
                    with_tax:'0',
                    status:'0',
                    pro_price:null,
                    pro_num:null
                };
                this.modalAdd=true;
            },
            show (param) {
                this.detailId = param.row.id;
                this.modalDetail=true;
             },
            edit (param) {
                this.formValidate=util.copy(param.row);
                this.formValidate.pro_price=Number.parseFloat( this.formValidate.pro_price);
                this.formValidate.pro_num=Number.parseInt( this.formValidate.pro_num);
                this.formValidate.invoice_date = this.formatDate(this.formValidate.invoice_date);
                this.formValidate.plan_date = this.formatDate(this.formValidate.plan_date);


                this.modalAdd=true;
             },
            remove (param) {
                let _self=this;
                this.loading=true;
                util.post(this,'biz/biz_order/delData',{id:param.row.id},function(datas){
                    _self.data.splice(param.index, 1);
                    _self.loading =false;
                    _self.$Message.success('删除成功！');
                });
            },
            addOkFun(){
                let _self=this;
                this.$refs['formRef'].validate((valid) => {
                    if (valid) {
                        util.changeModalLoading(this,true);
                        let _data=util.copy(this.formValidate);

                        _data.invoice_date = this.formatDate(_data.invoice_date);
                        _data.plan_date = this.formatDate(_data.plan_date);

                        if(this.formValidate&&this.formValidate.id){
                            util.post(this,'biz/biz_order/updateData',_data,function(datas){
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun();
                                _self.init();
                            });
                        }else{
                            util.post(this,'biz/biz_order/addData',_data,function(datas){
                                _self.$Message.success('新增成功！');
                                _self.addCanFun();
                                _self.init();
                            });
                        }
                    }else{
                        util.changeModalLoading(this);
                    }
                })
            },
            addCanFun(){
                this.modalAdd=false;
                util.changeModalLoading(this);
                this.$refs['formRef'].resetFields();
            }
        },
        mounted () {

            this.order_status_dict=util.showDictList('order_status');
            this.pay_status_dict=util.showDictList('pay_status');
            this.pay_type_dict=util.showDictList('pay_type');
            this.custom_dict=util.showDictList('custom');

            this.init();
        }
    }
</script>
