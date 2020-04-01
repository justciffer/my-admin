<style lang="less">
     .table-min-width{
        min-width:120px;
        width:120px
    }
</style>
<template>
     <div>
        <Row>
            <Col span="24">
                <Card>
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        订单流程列表
                    </p>
                    <Row>
                        状态 0-待处理 1-处理中 2-完成 3-取消：<Input v-model="searchForm.status" placeholder="请输入要搜索的状态 0-待处理 1-处理中 2-完成 3-取消" style="width: 200px;margin-right: 20px;" />
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
            </Col>
        </Row>
        <Modal  title="编辑"  :mask-closable="false" :closable="false" v-model="modalAdd">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="80">
                <FormItem label="完成时间" prop="finish_date">
                    <Input v-model="formValidate.finish_date"></Input>
                </FormItem>
                <FormItem label="表单数据" prop="form_data">
                    <Input v-model="formValidate.form_data"></Input>
                </FormItem>
                <FormItem label="订单id" prop="order_id">
                    <Input v-model="formValidate.order_id"></Input>
                </FormItem>
                <FormItem label="预计时间" prop="plan_date">
                    <Input v-model="formValidate.plan_date"></Input>
                </FormItem>
                <FormItem label="数量" prop="pro_num">
                    <Input v-model="formValidate.pro_num"></Input>
                </FormItem>
                <FormItem label="备注" prop="remarks">
                    <Input v-model="formValidate.remarks"></Input>
                </FormItem>
                <FormItem label="状态 0-待处理 1-处理中 2-完成 3-取消" prop="status">
                    <Input v-model="formValidate.status"></Input>
                </FormItem>
                <FormItem label="用户id" prop="user_id">
                    <Input v-model="formValidate.user_id"></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="addCanFun" v-show="modalCanBut">取消</Button>
                <Button type="primary" @click="addOkFun" :loading="modalLoading">确定</Button>
            </div>
        </Modal>    
        <Modal  title="详情" v-model="modalDetail">
            <Form :model="formValidate" :label-width="80">
                <FormItem label="完成时间">
                    <Input v-model="formValidate.finish_date" readonly></Input>
                </FormItem>
                <FormItem label="表单数据">
                    <Input v-model="formValidate.form_data" readonly></Input>
                </FormItem>
                <FormItem label="订单id">
                    <Input v-model="formValidate.order_id" readonly></Input>
                </FormItem>
                <FormItem label="预计时间">
                    <Input v-model="formValidate.plan_date" readonly></Input>
                </FormItem>
                <FormItem label="数量">
                    <Input v-model="formValidate.pro_num" readonly></Input>
                </FormItem>
                <FormItem label="备注">
                    <Input v-model="formValidate.remarks" readonly></Input>
                </FormItem>
                <FormItem label="状态 0-待处理 1-处理中 2-完成 3-取消">
                    <Input v-model="formValidate.status" readonly></Input>
                </FormItem>
                <FormItem label="用户id">
                    <Input v-model="formValidate.user_id" readonly></Input>
                </FormItem>
            </Form>
            <div slot="footer">
            </div>
        </Modal>    
    </div>
</template>
<script>
    import util from '@/libs/util.js';
    export default {
        data () {
            return {
                modalAdd:false,
                modalDetail:false,
                loading:false,
                modalLoading:false,
                modalCanBut:true,
                searchForm:{
                    current:1
                },
                data: [],
                formValidate: {
                },
                count:0,
                columns: [     
                    {
                        title: '创建时间',
                        key: 'create_date',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '订单id',
                        key: 'order_id',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '预计时间',
                        key: 'plan_date',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '数量',
                        key: 'pro_num',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '状态 0-待处理 1-处理中 2-完成 3-取消',
                        key: 'status',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '用户id',
                        key: 'user_id',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '操作',
                        key: 'action',
                        width: 210,
                        align: 'center',
                        render: (h, params) => {
                            return h('div', [
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
                ruleValidate: {
                    finish_date: [
                        { required: true, message: '完成时间为必填项'}
                    ],
                    form_data: [
                        { required: true, message: '表单数据为必填项'}
                    ],
                    order_id: [
                        { required: true, message: '订单id为必填项'}
                    ],
                    plan_date: [
                        { required: true, message: '预计时间为必填项'}
                    ],
                    pro_num: [
                        { required: true, message: '数量为必填项'}
                    ],
                    remarks: [
                        { required: true, message: '备注为必填项'}
                    ],
                    status: [
                        { required: true, message: '状态 0-待处理 1-处理中 2-完成 3-取消为必填项'}
                    ],
                    user_id: [
                        { required: true, message: '用户id为必填项'}
                    ],
                }
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                util.post(this,'biz/biz_order_process/pageData',this.searchForm,function(datas){   
                    _self.data=datas.data;
                    _self.count=datas.count;
                    _self.loading=false;
                });
            },
            handleSearch(){
                this.searchForm.current=1;
                this.init();
            },
            pageChange(current){
                this.searchForm.current=current;
                this.init();
            },
            add (){     
                this.formValidate={}; 
                this.modalAdd=true;       
            },
            show (param) {
                this.formValidate=util.copy(param.row);
                this.modalDetail=true;        
             },
            edit (param) {
                this.formValidate=util.copy(param.row);
                this.modalAdd=true;        
             },
            remove (param) {
                let _self=this;
                this.loading=true;
                util.post(this,'biz/biz_order_process/delData',{id:param.row.id},function(datas){ 
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
                        if(this.formValidate&&this.formValidate.id){
                            util.post(this,'biz/biz_order_process/updateData',_data,function(datas){  
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun();
                                _self.init();      
                            });                        
                        }else{
                            util.post(this,'biz/biz_order_process/addData',_data,function(datas){ 
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
            this.init();
        }
    }
</script>