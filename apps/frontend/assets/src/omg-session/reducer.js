import createReducer from '../reducer/createReducer'
export const sessionReducer = createReducer(
  {},
  {
    'SESSION/LOGIN/SUCCESS': (state, action) => {
      return { authenticated: true }
    },
    'SESSION/LOGOUT/SUCCESS': (state, action) => {
      return { authenticated: false }
    }
  }
)
