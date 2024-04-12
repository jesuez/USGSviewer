import http from "../http-common";

class DataService {
  getAll(data) {
     let params ='';
     if (data) {
         if (data.perPage) params += ("/number/"+data.perPage);
         if (data.currentPage) params += ("/page/"+data.currentPage);
         if (data.selected && data.selected.length) params += ("/magtype/"+data.selected.join('-'));
     }
    return http.get("/features"+params);
  }

  get(id) {
    return http.get(`/features/${id}`);
  }

  comment(id,data) {
    return http.post(`/features/${id}/comment/new`, {comment: data});
  }

  update(id, data) {
    return http.put(`/features/${id}`, {feature:data});
  }
}

export default new DataService();

