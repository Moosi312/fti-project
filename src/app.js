// import 'bootstrap/dist/css/bootstrap.min.css';
import '../assets/styles/app.scss'
// import '../assets/styles/fonts.css'

import * as d3 from "d3";
d3.formatDefaultLocale({
	decimal: ',',
	thousands: '.'
})

import { Modal } from 'bootstrap'
window.Modal = Modal
// import 'bootstrap';


import Vue from 'vue'
import App from './App.vue'

import { store } from './store.js'
import { router } from './router.js'

if(process.env.NODE_ENV == 'production') {
    require('./matomo.js')
} else {
    console.log(process.env.NODE_ENV)
}

window.v = new Vue({ // eslint-disable-line no-new
    el: '#app',
    router: router,
    store: store,
    render: h => h(App)
})
