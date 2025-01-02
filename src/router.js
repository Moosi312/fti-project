import Vue from 'vue';
import VueRouter from 'vue-router';

import App from "./App.vue";


Vue.use(VueRouter)

export const router = new VueRouter({
    base: '/',
    mode: 'history',
    routes: [{
        name: 'home',
        path: '/',
        redirect: '/O/system',
        // component: App
    }, {
        name: 'overview',
        path: '/O/:view',
        component: App
    }, {
        name: 'topic',
        path: '/B/:nr',
        component: App,
    }, {
        name: 'target',
        path: '/Z/:id',
        component: App
    }, {
        name: 'bar',
        path: '/svg',
        component: App
    }, {
        name: 'print',
        path: '/P',
        component: App
    }, {
        name: 'connection',
        path: '/connection',
        component: App
    }, {
        name: 'test',
        path: '/test',
        component: App
    }]
})

router.beforeEach((to, from, next) => {
    if (document.body.classList.contains('modal-open')) {
        const m = document.getElementsByClassName("modal show")[0];
        window.Modal.getInstance(m).hide()
        next(false)
    } else {
        next()
    }
})
