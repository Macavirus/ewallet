import request from './api_service';

export function getAll(params, callback) {
  const {
    per, sort, query, ...rest
  } = params;
  const requestParams = {
    path: 'account.all',
    params: JSON.stringify({
      per_page: per, sort_by: sort.by, sort_dir: sort.dir, search_term: query, ...rest,
    }),
    authenticated: true,
    callback,
  };
  return request(requestParams);
}

export function create(params, callback) {
  const requestParams = {
    path: 'account.create',
    params: JSON.stringify(params),
    authenticated: true,
    callback,
  };
  return request(requestParams);
}

export function get(id, callback) {
  const requestParams = {
    path: 'account.get',
    params: JSON.stringify({ id }),
    authenticated: true,
    callback,
  };
  return request(requestParams);
}
