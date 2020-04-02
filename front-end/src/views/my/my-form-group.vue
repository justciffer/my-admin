<template>
    <!--<Form :lable-width="lableWidth">-->
    <div>
        <FormItem
                v-for="(item,index) in items"
                :label="item.label"
                :key = "`${_uid}_${index}`"
        >
            <component :is="item.type" :range="item.range" v-model="item.value">
                <!--做判断是否有children 属性，有的话就做组合组件效果 label 是给radio用的 用来单选-->
                <template v-if="item.children">
                    <component
                            v-for="(child,i) in item.children.list"
                            :key="`${_uid}_${index}_${i}`"
                            :value="child.value"
                            :label="child.label"
                            :is="item.children.type"
                    >
                        {{child.label}}
                    </component>
                </template>
            </component>
        </FormItem>
    </div>
    <!--</Form>-->
</template>


<script>
    /**
     * 1.list 接受从父组件传递过来的定义渲染接口的内容值
     * 2.利用动态根据传递过来的list 中的type 进行组件渲染
     * 3.小技巧利用_uid 和 index 搭配生成唯一的 key
     **/
    import util from '@/libs/util.js';

    export default {
        name: "myFormGroup",
        data () {
            return {
                items:[]
            };
        },
        props:{
            list:{
                type:Array,
                default:()=>{}
            }
        },

        created () {
            this.init();
        },
        methods: {
            init () {
                this.items=[];


                //todo：type 字典的值对应组件
                this.list.forEach(_c=>{
                    let _t = _c.type.startsWith('dict_') ? 'Select' : _c.type;

                    let  _item={
                        name:_c.key,
                        type:_t,
                        label:_c.name,
                        value:_c.value? _c.value : ''
                    };

                    if(_t == 'Select'){
                        let dict_key = _c.type.replace('dict_','');
                        let dict_list =util.showDictList(dict_key);
                        _item.children = {type:'Option',list:dict_list};
                    }

                    this.items.push(_item);
                });


                console.log(this.items);
            }
        },

        watch: {

            list: {
                handler () {
                    this.init();
                    //[{"type":"dict_outsource","key":"com","name":"素烧外协"}]


                    /*  this.stepForm=[{
                                      name:'name',
                                      type:'i-input',
                                      value:'',
                                      label:'姓名',
                                      rule:[
                                          { required: true, message: 'The name cannot be empty', trigger: 'blur' }
                                      ],
                                  },{
                                      name:'range',
                                      type:'slider',
                                      value:[10,40],
                                      range:true,
                                      label:'范围'
                                  },{
                                      name:'select',
                                      type:'i-select',
                                      value:'',
                                      label:'性别',
                                      children:{
                                          type:'i-option',
                                          list:[
                                              {value:'man',title:'男'},
                                              {value:'woman',title:'女'},
                                          ]
                                      }
                                  }];*/

                },
                deep: true,
                immediate: true,
            }
        }
    }
</script>

<style scoped>

</style>
