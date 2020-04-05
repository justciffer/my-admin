<style lang="less">
</style>
<template>
     <div>    
        <Row>
            <Col span="12">
                <Card>
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        {{page_title}}
                    </p>
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
        <Modal  title="操作框"  :mask-closable="false" :closable="false" v-model="modalAdd">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="80">
                <FormItem label="名称" prop="label">
                    <Input v-model="formValidate.label"></Input>
                </FormItem>
                <FormItem label="排序" prop="sort">
                    <InputNumber :min="1" v-model="formValidate.sort"></InputNumber>
                </FormItem>
                <FormItem label="备注" prop="remarks">
                    <Input v-model="formValidate.remarks"></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="addCanFun" v-show="modalCanBut">取消</Button>
                <Button type="primary" @click="addOkFun" :loading="modalLoading">确定</Button>
            </div>
        </Modal>    
    </div>
</template>

<script>
    import util from '@/libs/util.js';
    export default {
        data () {
            return {
                page_title:'付款方式',
                page_type:'pay_type',
                modalAdd:false,
                modalEdit:false,
                loading:false,
                modalLoading:false,
                modalCanBut:true,
                searchForm:{
                    type:'',
                    current:1
                },
                count:0,
                columns: [
                    {
                        title: '排序',
                        key: 'sort'
                    },
                    {
                        title: '标签',
                        key: 'label'
                    },
                    {
                        title: '备注',
                        key: 'remarks'
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
                data: [],
                formValidate: {
                    sort: 1
                },
                ruleValidate: {
                    label: [
                        { required: true, message: '必填项', trigger: 'blur' }
                    ],
                }
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                this.searchForm.type= this.page_type;
                util.post(this,'admin/sys_dict/pageData',this.searchForm,function(datas){                  
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
                this.formValidate={sort: 1};
                this.formValidate.type=this.page_type;
                this.formValidate.value=this.page_type+"#" + util.uuid();
                this.formValidate.description=this.page_title;
                this.modalAdd=true;            
            },
            edit (param) {
                this.formValidate=util.copy(param.row);
                this.formValidate.type=this.page_type;
                this.modalAdd=true;                          
            },
            remove (param) {
                let _self=this;
                this.loading=true;
                util.post(this,'admin/sys_dict/delData',{id:param.row.id},function(datas){ 
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
                            util.post(this,'admin/sys_dict/updateData',_data,function(datas){                  
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun();  
                                _self.init();        
                            });                          
                        }else{
                            util.post(this,'admin/sys_dict/addData',_data,function(datas){                  
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