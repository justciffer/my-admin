<style lang="less">
     .table-min-width{
        min-width:120px;
        width:120px
    }
</style>
<template>
     <div>
        <Row>
            <Col :span="span1">
                <Card>
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        父分类列表
                    </p>
                    <Row>
                        名称：<Input v-model="searchForm.name" placeholder="请输入要搜索的名称" style="width: 200px;margin-right: 20px;" />
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
            <Col span="12" v-show="isShow">
                <Card>
                    <p slot="title">
                        <Icon type="ios-list"></Icon>
                        【{{pParam.name}}】的子分类列表
                    </p>
                    <Row>
                        名称：<Input v-model="searchForm2.name" placeholder="请输入要搜索的名称" style="width: 200px;margin-right: 20px;" />
                        <span @click="handleSearch2"><Button type="primary" icon="search">搜索</Button></span>
                    </Row>
                    <Row style="margin-top:10px;">
                        <Button type="info" @click="add2">添加</Button>
                    </Row>
                    <Row type="flex" justify="center" align="middle" class="advanced-router">
                        <Table border stripe :columns="columns2" :data="data2" :loading="loading2" style="width: 100%;margin-top:10px"></Table>
                        <Page :total="count2" :current="searchForm2.current" show-total  style="margin-top:10px;" @on-change="pageChange2"></Page>
                    </Row>
                </Card>
            </Col>
        </Row>
        <Modal  title="编辑"  :mask-closable="false" :closable="false" v-model="modalAdd">
            <Form ref="formRef" :model="formValidate" :rules="ruleValidate" :label-width="80">
                <FormItem label="名称" prop="name">
                    <Input v-model="formValidate.name"></Input>
                </FormItem>
                <FormItem label="排序" prop="sort_order">                   
                    <InputNumber :min="1" v-model="formValidate.sort_order"></InputNumber>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="addCanFun" v-show="modalCanBut">取消</Button>
                <Button type="primary" @click="addOkFun" :loading="modalLoading">确定</Button>
            </div>
        </Modal>    
        <Modal  title="详情"  v-model="modalDetail">
            <Form :model="formValidate" :label-width="80">
                <FormItem label="名称" prop="name">
                    <Input v-model="formValidate.name" readonly></Input>
                </FormItem>               
                <FormItem label="排序" prop="sort_order">
                    <Input v-model="formValidate.sort_order" readonly></Input>
                </FormItem>
            </Form>
            <div slot="footer">
            </div>
        </Modal>   
        <Modal  title="编辑"  :mask-closable="false" :closable="false" v-model="modalAdd2">
            <Form ref="formRef2" :model="formValidate2" :rules="ruleValidate2" :label-width="80"> 
                <FormItem label="名称" prop="name">
                    <Input v-model="formValidate2.name"></Input>
                </FormItem>
                <FormItem label="排序" prop="sort_order">
                    <InputNumber :min="1" v-model="formValidate2.sort_order"></InputNumber>
                </FormItem>              
            </Form>
            <div slot="footer">
                <Button type="text" @click="addCanFun2" v-show="modalCanBut">取消</Button>
                <Button type="primary" @click="addOkFun2" :loading="modalLoading">确定</Button>
            </div>
        </Modal>    
        <Modal  title="详情"  v-model="modalDetail2">
            <Form :model="formValidate2" :label-width="80">
                <FormItem label="名称" prop="name">
                    <Input v-model="formValidate2.name" readonly></Input>
                </FormItem>               
                <FormItem label="排序" prop="sort_order">
                   <Input v-model="formValidate2.sort_order" readonly></Input>
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
                span1:24,
                imgDataUrl1:'',
                imgDataUrl2:'',
                imgDataUrl3:'',
                isShow:false,
                p_name:'',
                pParam:{},
                modalAdd:false,
                modalDetail:false,
                modalAdd2:false,
                modalDetail2:false,
                loading2:false,
                loading:false,
                modalLoading:false,
                modalCanBut:true,
                searchForm:{
                    current:1
                },
                count:0,
                columns: [     
                    {
                        title: '名称',
                        key: 'name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '排序',
                        key: 'sort_order',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '操作',
                        key: 'action',
                        width: 250,
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
                                        type: 'warning',
                                        size: 'small'
                                    },
                                    style: {
                                        marginRight: '5px'
                                    },
                                    on: {
                                        click: () => {
                                            this.showChild(params)
                                        }
                                    }
                                }, '子分类'),
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
                    sort_order: 1
                },
                ruleValidate: {
                    name: [
                        { required: true, message: '名称为必填项' }
                    ],
                    sort_order: [
                        { required: true, message: '排序为必填项' }
                    ]
                },         
                searchForm2:{
                    current:1
                },
                count2:0,
                columns2: [     
                    {
                        title: '名称',
                        key: 'name',
                        className: 'table-min-width',
                        ellipsis:true,
                        align: 'center',
                    },
                    {
                        title: '排序',
                        key: 'sort_order',
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
                                            this.show2(params)
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
                                            this.edit2(params)
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
                                           this.remove2(params);
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
                data2: [],
                formValidate2: {
                    sort_order: 1
                },
                ruleValidate2: {
                    name: [
                        { required: true, message: '名称为必填项' }
                    ],
                    sort_order: [
                        { required: true, message: '排序为必填项' }
                    ]
                }
            }
        },
        methods: {
            init () {
                let _self=this;
                _self.loading=true;
                util.post(this,'wx/admin/wx_attribute_category/pageData',this.searchForm,function(datas){   
                    _self.data=datas.data;
                    _self.count=datas.count;
                    _self.loading=false;
                });
            },
            handleSearch(){
                this.searchForm.current=1;
                // this.span1=24;
                // this.isShow=false;
                this.init();
            },
            pageChange(current){
                this.searchForm.current=current;
                this.init();
            },
            add (){     
                this.formValidate={
                    sort_order: 1
                }; 
                this.imgDataUrl1='';
                this.imgDataUrl2='';
                this.modalAdd=true;       
            },
            show (param) {
                this.formValidate=util.copy(param.row);
                this.imgDataUrl1=UPLOAD_IMG_URL+this.formValidate.icon_url;
                this.imgDataUrl2=UPLOAD_IMG_URL+this.formValidate.wap_banner_url;
                this.modalDetail=true;        
             },
            edit (param) {
                this.formValidate=util.copy(param.row);
                this.imgDataUrl1=UPLOAD_IMG_URL+this.formValidate.icon_url;
                this.imgDataUrl2=UPLOAD_IMG_URL+this.formValidate.wap_banner_url;
                this.modalAdd=true;        
             },
            remove (param) {
                let _self=this;
                this.loading=true;
                util.post(this,'wx/admin/wx_attribute_category/delData',{id:param.row.id},function(datas){ 
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
                            util.post(this,'wx/admin/wx_attribute_category/updateData',_data,function(datas){  
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun();
                                _self.init();      
                            });                        
                        }else{
                            util.post(this,'wx/admin/wx_attribute_category/addData',_data,function(datas){ 
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
            },
            showChild(param){
                let _self=this;               
                this.span1=12;
                this.pParam=util.copy(param.row);
                this.isShow=true;
                this.handleSearch2();
            },
            handleUpload1 (file) {
                let _self=this;
                util.imageUpload(this,file,function(datas){
                    _self.imgDataUrl1=UPLOAD_IMG_URL+datas; // Get url from response
                    _self.formValidate.icon_url=datas;
                });      
                return false;
            },
            handleUpload2 (file) {
                let _self=this;
                util.imageUpload(this,file,function(datas){
                    _self.imgDataUrl2=UPLOAD_IMG_URL+datas; // Get url from response
                    _self.formValidate.wap_banner_url=datas;
                });      
                return false;
            },
            handleUpload3 (file) {
                let _self=this;
                util.imageUpload(this,file,function(datas){
                    _self.imgDataUrl3=UPLOAD_IMG_URL+datas; // Get url from response
                    _self.formValidate2.wap_banner_url=datas;
                });      
                return false;
            },
            init2 () {
                let _self=this;
                _self.loading2=true;
                this.searchForm2.pid=this.pParam.id;
                util.post(this,'wx/admin/wx_attribute/pageData',this.searchForm2,function(datas){   
                    _self.data2=datas.data;
                    _self.count2=datas.count;
                    _self.loading2=false;
                });
            },
            handleSearch2(){
                this.searchForm2.current=1;
                this.init2();
            },
            pageChange2(current){
                this.searchForm2.current=current;
                this.init2();
            },
            add2 (){     
                this.formValidate2={sort_order:1}; 
                this.imgDataUrl2='';
                this.modalAdd2=true;       
            },
            show2 (param) {
                this.formValidate2=util.copy(param.row);
                this.imgDataUrl3=UPLOAD_IMG_URL+this.formValidate2.wap_banner_url;
                this.modalDetail2=true;        
             },
            edit2 (param) {
                this.formValidate2=util.copy(param.row);
                this.imgDataUrl3=UPLOAD_IMG_URL+this.formValidate2.wap_banner_url;
                this.modalAdd2=true;        
             },
            remove2 (param) {
                let _self=this;
                this.loading2=true;
                util.post(this,'wx/admin/wx_attribute/delData',{id:param.row.id},function(datas){ 
                    _self.data2.splice(param.index, 1);
                    _self.loading2=false;      
                    _self.$Message.success('删除成功！');
                });
            },
            addOkFun2(){
                let _self=this;
                this.$refs['formRef2'].validate((valid) => {
                    if (valid) {
                        util.changeModalLoading(this,true);
                        let _data=util.copy(this.formValidate2); 
                        _data.attribute_category_id=_self.pParam.id;
                        if(this.formValidate2&&this.formValidate2.id){
                            util.post(this,'wx/admin/wx_attribute/updateData',_data,function(datas){  
                                _self.$Message.success('编辑成功！');
                                _self.addCanFun2();
                                _self.init2();      
                            });                        
                        }else{
                            util.post(this,'wx/admin/wx_attribute/addData',_data,function(datas){ 
                                _self.$Message.success('新增成功！');
                                _self.addCanFun2(); 
                                _self.init2();     
                            });     
                        }
                    }else{
                        util.changeModalLoading(this);
                    } 
                })  
            },   
            addCanFun2(){ 
                this.modalAdd2=false; 
                util.changeModalLoading(this);
                this.$refs['formRef2'].resetFields(); 
            }
        },
        mounted () {
            this.init();
        }
    }
</script>