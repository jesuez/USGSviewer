<template>
  <div class="list row">
   <div class="col-6 mb-12">
     <h2>Featureslist</h2>
   </div>
    <div class="col-md-12 row">
    <div class="col-md-6">
        <div class="form-group">
            <Multiselect
              v-model="toFilter.selected"
              mode="tags"
              :close-on-select="false"
              :searchable="true"
              :create-option="true"
              :options="options"
            />
          <small class="form-text text-muted">Magnitude type, you can select multiple types.</small>
        </div>
    </div>
    <div class="col-md-2">
        <div class="form-group">
            <input type="number" step="1" min="0" max="1000" class="form-control" placeholder="Records per page"
               v-model="toFilter.perPage"/>
          <small class="form-text text-muted">Records per page, max 1000.</small>
        </div>
        
    </div>
    <div class="col-md-2">
        <div class="form-group">
          <button class="btn btn-outline-secondary" type="button"
            @click="retrieveFeatures(toFilter)"
          >
            Search
          </button>
          <small class="form-text text-muted">Filter records.</small>
        </div>
        
    </div>
    <div class="col-md-2">
        <div class="form-group">
          <button class="btn btn-outline-danger" type="button"
            @click="refreshList"
          >
            Clear
          </button>
          <small class="form-text text-muted">Reload / Clear filters.</small>
        </div>
        
    </div>
    </div>
    <div class="col-md-8 mb-3">

   <div class="card">
     <h5 class="card-header">
      <div class="row">
         <div class="col-md-4">
            Features List
         </div>
         <div class="col-md-8">
          <small class="form-text text-muted"><strong>Total records:</strong> {{toFilter.total}}, <strong>Total pages:</strong> {{toFilter.numberPages}}</small>
         </div>
      </div>
     </h5>
   <div class="btn-group" role="group">
     <button type="button" class="btn btn-secondary" style="width: 300px;"
       @click="goToPage(toFilter.currentPage-1)"
       :disabled="toFilter.currentPage<=1"
     >&#10094;&#10094; Previous </button>
        <div class="input-group">
        <div class="input-group-prepend">
          <span class="input-group-text">Current page: {{toFilter.currentPage}}</span>
        </div>
            <input type="number" step="1" min="1" max="{{toFilter.numberPages}}" class="form-control" placeholder="Page"
               v-model="toFilter.goToPage"/>
        <div class="input-group-append">
          <button class="btn btn-outline-secondary" type="button"
            :disabled="toFilter.goToPage<1||toFilter.goToPage>toFilter.numberPages"
                  @click="goToPage(toFilter.goToPage)"
            >Go &#9992;</button>
        </div>
      </div>
     <button type="button" class="btn btn-secondary" style="width: 300px;"
       :disabled="toFilter.currentPage>=toFilter.numberPages"
       @click="goToPage(toFilter.currentPage+1)"
      > Next &#10097;&#10097;</button>
   </div>
     <ul class="list-group list-group-flush">
        <li class="list-group-item"
          :class="{ active: index == currentIndex }"
          v-for="(feature, index) in features"
          :key="index"
          @click="setActiveFeature(feature, index)"
        >
          <strong>{{ feature.attributes.external_id }}:</strong> 
          {{ feature.attributes.title }}
        </li>
     </ul>
   </div>

    </div>
    <div class="col-md-4">
      <div class="card">
        <h5 class="card-header">Preview</h5>
        <div class="card-body">
            <div v-if="currentFeature">
              <div>
                <label><strong>Identifier:</strong></label> {{ currentFeature.attributes.external_id }}
              </div>
              <div>
                <label><strong>Magnitude:</strong></label> {{ currentFeature.attributes.magnitude }}
              </div>
              <div>
                <label><strong>Tsunami:</strong></label> {{ currentFeature.attributes.tsunami=="0" ? "No" : "Yes" }}
              </div>
              <div>
                <label><strong>Title:</strong></label> {{ currentFeature.attributes.title }}
              </div>
              <div>
                <label><strong>Place:</strong></label> {{ currentFeature.attributes.place }}
              </div>
      
              <router-link :to="'/features/' + currentFeature.id" class="btn btn-outline-primary" style="min-width:100px;">Details</router-link>
            </div>
            <div v-else>
              <br />
              <h5 class="card-title">
                 <p>Please click on a Feature...</p>
              </h5>
            </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DataService from "../services/DataService";
  import Multiselect from '@vueform/multiselect';
export default {
  name: "features-list",
  components: {
    Multiselect,
  },
  data() {
    return {
      features: [],
      toFilter:{
        numberPages: null,
        currentPage: null,
        perPage: null,
        total: 0,
        selected: null,
      },
      options: [],
      currentFeature: null,
      currentIndex: -1,
    };
  },
  methods: {
    retrieveFeatures(data=null) {
    this.toFilter.currentPage = 1;
      DataService.getAll(data??this.toFilter)
        .then(response => {
          this.features = response.data.data;
          this.toFilter = {
              currentPage: response.data.pagination.current_page,
              perPage: response.data.pagination.per_page,
              total: response.data.pagination.total,
              selected: response.data.pagination.magtype,
              numberPages: ((response) => {
               let pages = Math.floor(response.data.pagination.total/response.data.pagination.per_page);
               if (Math.floor(response.data.pagination.total%response.data.pagination.per_page))
                  pages++;
               return pages;
              })(response)
            }
            if (this.toFilter.currentPage>this.toFilter.pages) this.toFilter.currentPage = 1;
            if (this.toFilter.currentPage>this.toFilter.pages) this.toFilter.currentPage = 1;
            this.options = response.data.pagination.mag_types;
        })
        .catch(e => {
          console.log(e);
        });
    },

    goToPage(x) {
      if (x<1 || x>this.toFilter.pages) return;
      let clone = structuredClone(this.toFilter);
      clone.currentPage = x;
      this.retrieveFeatures(clone);
    },

    refreshList() {
      this.currentFeature = null;
      this.currentIndex = -1;
      this.toFilter = {
        goToPage: null,
        currentPage: null,
        perPage: null,
        total: 0,
        selected: [],
        pages:0
      }
      this.retrieveFeatures();
    },

    setActiveFeature(feature, index) {
      this.currentFeature = feature;
      this.currentIndex = feature ? index : -1;
    }
  },
  mounted() {
    this.retrieveFeatures();
  }
};
</script>
<style src="@vueform/multiselect/themes/default.css"></style>
<style>
    button {min-width:100px;}
   .list {
     text-align: left;
     margin: auto;
   }
</style>
