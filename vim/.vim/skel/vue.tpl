<template>
  <div class="m-x">
    <div class="hd">

    </div>
    <div class="bd">

    </div>
    <div class="ft">

    </div>
  </div>
</template>
<script lang="ts">
import { Component, Prop, Watch, Emit, Vue } from 'vue-property-decorator'
import { namespace } from 'vuex-class'

@Component({
  components: { /* components */ }
})
export default class X extends Vue {
  @Prop(String)
  value!: string;

  mounted () {
    console.log('x mounted')
  }
}
</script>
<style lang="scss">
.m-x {
  .hd {

  }
  .bd {

  }
  .ft {

  }
}
</style>
