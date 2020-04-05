<template>
    <Row>
        <iCol span="24" v-for="(item,index) in list" :key = "`${_uid}_${index}`">
            <iCol span="3" align="right">{{item.i_label}}：</iCol>   <iCol>{{item.i_value}}</iCol>
        </iCol>
    </Row>
</template>


<script>
    import util from '@/libs/util.js';

    export default {
        name: "myFormGroupRead",
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
                this.list.forEach(_c=>{
                    let _t = _c.type.startsWith('dict_') ? 'Select' : _c.type;
                    _c.i_label=_c.name;
                    _c.i_value=_c.value? _c.value : null;
                    if(_t == 'Select'){
                        let dict_key = _c.type.replace('dict_','');
                        _c.i_value=  util.showDictLabel(dict_key,_c.value);
                    }
                });
            }
        },

        watch: {

            list: {
                handler () {
                    this.init();
                },
                deep: true,
                immediate: true,
            }
        }
    }
</script>

<style scoped>

</style>
