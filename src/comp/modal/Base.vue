<template>
    <div class="modal fade" :id="id" tabindex="-1">
        <div :class="`modal-dialog modal-${size}`">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">{{ title }}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schliessen"></button>
                </div>
                <div class="modal-body">
                    <slot/>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        id: {}, 
        title: {}, 
        size: {
            default: 'lg'
        }
    }
}
</script>