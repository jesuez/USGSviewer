import { createWebHistory, createRouter } from "vue-router";
const routes =  [
  {
    path: "/",
    alias: "/features",
    name: "features",
    component: () => import("./components/Features_list")
  },
  {
    path: "/features/:id",
    name: "feature-details",
    component: () => import("./components/Feature_details")
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
