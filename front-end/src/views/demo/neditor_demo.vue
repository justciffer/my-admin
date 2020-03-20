<template>
  <div id="app">
      <div>
          <vue-editor id="editor" useCustomImageHandler @imageAdded="handleImageAdded" v-model="htmlForEditor">
          </vue-editor>      
      </div>
    </el-dialog>

  </div>
</template>

<script>
  import util from '@/libs/util.js';
  import { VueEditor } from 'vue2-editor'
  import axios from 'axios'
  export default{
      components: {
        VueEditor
      },
      data(){
        return {
          htmlForEditor: '',
          addFormVisible: false
        }
      },
      methods: {
        handleImageAdded: function(file, Editor, cursorLocation) {
          util.imageUpload(this,file,function(datas){
              let url = 'http://p2fovavhn.bkt.clouddn.com/'+datas; // Get url from response
              Editor.insertEmbed(cursorLocation, 'image', url);
          });  
        }
      }
  }

</script>
