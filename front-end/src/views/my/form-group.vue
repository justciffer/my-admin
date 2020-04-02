<template>
    <Form :lable-width="lableWidth">
        <FormItem
                v-for="(item,index) in list"
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
                        {{child.title}}
                    </component>
                </template>
            </component>
        </FormItem>
    </Form>
</template>


<script>
    /**
     * 1.list 接受从父组件传递过来的定义渲染接口的内容值
     * 2.利用动态根据传递过来的list 中的type 进行组件渲染
     * 3.小技巧利用_uid 和 index 搭配生成唯一的 key
     **/
    export default {
        name: "FormGroup",
        props:{
            list:{
                type:Array,
                default:()=>{}
            }
            // ,
            // lableWidth:{
            //     type:Number,
            //     default:100
            // }
        }
    }
</script>

<style scoped>

</style>
