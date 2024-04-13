<template>
  <div v-if="currentFeature" class="row">
     <div class="col-lg-3">
       <a class="btn btn-link" href="/">&#10096;&#10096; Back to list</a>
     </div>
      <div class="col-6 mb-3">
        <h2>Feature: {{currentFeature.attributes.external_id}}</h2>
      </div>
      <div class="col-lg-3"></div>
      <div class="col-6">
        <div class="card">
          <h5 class="card-header">Details</h5>
          <div class="card-body">
            <p class="card-text">{{ message }}</p>

                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">Title:</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext"
                      v-show="!updater.open"
                      >{{currentFeature.attributes.title}}</span>
                      <input type="text" class="form-control" id="title"
                      v-model="updater.title"
                      v-show="updater.open"
                            />
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">Magnitude:</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext"
                      v-show="!updater.open"
                      >{{currentFeature.attributes.magnitude}}</span>
                      <input type="number" step="0.01" min="-1" max="10" class="form-control" id="magnitude"
                      v-model="updater.magnitude"
                      v-show="updater.open"
                            />
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">Magnitude type:</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext"
                      v-show="!updater.open"
                      >{{currentFeature.attributes.mag_type}}</span>
                      <input type="text" class="form-control" id="mag_type"
                      v-model="updater.mag_type"
                      v-show="updater.open"
                            />
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">Tsunami:</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext">{{(currentFeature.attributes.tsunami == '0'?'No':'Yes')}}</span>
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">time:</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext">{{currentFeature.attributes.time}}</span>
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">Latitude</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext">{{currentFeature.attributes.coordinates.latitude}}</span>
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">Longitude</label>
                    <div class="col-lg-9">
                      <span class="form-control-plaintext">{{currentFeature.attributes.coordinates.longitude}}</span>
                    </div>
                  </div>
            
                  <div class="form-group row">
                    <label class="col-lg-3 col-form-label">External link</label>
                    <div class="col-lg-9">
                      <a class="btn btn-link" target="_blank" :href="`${currentFeature.links.external_url}`">{{currentFeature.attributes.title}}</a>
                    </div>
                  </div>

            <button type="submit" class="btn btn-outline-success"
                v-show="updater.open"
              @click="updateFeature"
            >
              Update
            </button>
                <button type="button" class="btn btn-outline-danger"
                    v-show="updater.open"
              @click="openUpdate"
              >
              cancel
                </button>
                <button type="button" class="btn btn-outline-primary"
                    v-show="!updater.open"
              @click="openUpdate"
              >
              Edit
                </button>
          </div>
        </div>

      </div>
      <div class="col-6">

            <div class="card">
              <h5 class="card-header">Comments</h5>
              <div class="card-body">
                  <div class="input-group mb-3">
                    <input type="text" class="form-control" placeholder="Write a comment"
                      v-model="comment"/>
                    <div class="input-group-append">
                      <button class="btn btn-outline-primary" type="button"
                        @click="addComent"
                      >
                        Add Comment
                      </button>
                    </div>
                  </div>
                <p class="card-text"
                  v-for="(comment, index) in comments"
                  :key="index"
                >-{{ comment.body }}-</p>
              </div>
            </div>
      </div>
  </div>

  <div v-else>
    <br />
    <p>Please click on a Feature...</p>
  </div>
</template>

<script>
import DataService from "../services/DataService";

export default {
  name: "feature-details",
  data() {
    return {
      currentFeature: null,
      comments: [],
      message: '',
      comment: '',
      updater: null
    };
  },
  methods: {
    getFeature(id) {
      DataService.get(id)
        .then(response => {
          this.currentFeature = response.data.data;
          this.comments = response.data.comments;
        })
        .catch(e => {
          console.log(e);
        });
    },

    updateFeature() {
        if (!this.updater.title || !this.updater.mag_type || isNaN(this.updater.magnitude)
            || this.updater.magnitude < -1 || this.updater.magnitude > 10) {
                this.message = 'Incorrect data values!';
                return
        }
      DataService.update(this.currentFeature.id, this.updater)
        .then(() => {
          this.message = 'The feature was updated successfully!';
          this.openUpdate()
          this.getFeature(this.currentFeature.id)
        })
        .catch(e => {
          console.log(e);
        });
    },
        addComent() {
        if (!this.comment) return;

      DataService.comment(this.currentFeature.id, { body: this.comment})
        .then(() => {
          this.message = 'The comment was stored successfully!';
          this.comment = '';
          this.getFeature(this.currentFeature.id)
        })
        .catch(e => {
          console.log(e);
        });
    },

    openUpdate() {
        if (this.updater.open) {
            this.updater.title = null;
            this.updater.magnitude = null;
            this.updater.mag_type = null;
        }else {
            this.updater.title = this.currentFeature.attributes.title;
            this.updater.magnitude = this.currentFeature.attributes.magnitude;
            this.updater.mag_type = this.currentFeature.attributes.mag_type;
        }
        this.updater.open = !this.updater.open ;
    }
  },
  mounted() {
    this.updater = {
          title: null,
          open: false,
      };
    this.message = '';
    this.comment = '';
    this.getFeature(this.$route.params.id);
  }
};
</script>
<style>
    button {min-width:100px; margin-right: 2em;}
    p {text-align: left;}
</style>
