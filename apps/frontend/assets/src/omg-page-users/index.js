import React, { Component } from 'react'
import PropTypes from 'prop-types'
import moment from 'moment'
import queryString from 'query-string'

import TopNavigation from '../omg-page-layout/TopNavigation'
import styled from 'styled-components'
import SortableTable from '../omg-table'
import { Button, Icon } from '../omg-uikit'
import ExportModal from '../omg-export-modal'
import UsersFetcher from '../omg-users/usersFetcher'
import { withRouter } from 'react-router-dom'
import Copy from '../omg-copy'
import { createSearchUsersQuery } from '../omg-users/searchField'

const UserPageContainer = styled.div`
  position: relative;
  padding-bottom: 100px;
  td:nth-child(1) {
    border: none;
    position: relative;
    :before {
      content: '';
      position: absolute;
      right: 0;
      bottom: -1px;
      height: 1px;
      width: calc(100% - 50px);
      border-bottom: 1px solid ${props => props.theme.colors.S200};
    }
  }
  tr:hover {
    td:nth-child(1) {
      i {
        visibility: visible;
      }
    }
  }
  i[name='Copy'] {
    margin-left: 5px;
    cursor: pointer;
    visibility: hidden;
    color: ${props => props.theme.colors.S500};
    :hover {
      color: ${props => props.theme.colors.B300};
    }
  }
`
const SortableTableContainer = styled.div`
  position: relative;
  td {
    white-space: nowrap;
  }
`
const UserIdContainer = styled.div`
  white-space: nowrap;
  span {
    vertical-align: middle;
  }
  i[name='Profile'] {
    margin-right: 5px;
    color: ${props => props.theme.colors.B100};
    padding: 8px;
    border-radius: 6px;
    border: 1px solid ${props => props.theme.colors.S400};
  }
`
class UsersPage extends Component {
  static propTypes = {
    location: PropTypes.object,
    history: PropTypes.object,
    divider: PropTypes.bool,
    scrollTopContentContainer: PropTypes.func,
    query: PropTypes.object,
    fetcher: PropTypes.func,
    onClickRow: PropTypes.func
  }

  static defaultProps = {
    query: {},
    fetcher: UsersFetcher
  }
  constructor (props) {
    super(props)
    this.state = {
      createAccountModalOpen: false,
      exportModalOpen: false
    }
  }
  onClickRow = (data, index) => e => {
    this.props.history.push(`/users/${data.id}`)
  }
  renderExportButton = () => {
    return (
      <Button size='small' styleType='ghost' onClick={this.onClickExport} key={'export'}>
        <Icon name='Export' /><span>Export</span>
      </Button>
    )
  }
  renderCreateAccountButton = () => {
    return (
      <Button size='small' onClick={this.onClickCreateAccount} key={'create'}>
        <Icon name='Plus' /><span>Create Account</span>
      </Button>
    )
  }
  getColumns = () => {
    return [
      { key: 'id', title: 'USER ID', sort: true },
      { key: 'email', title: 'EMAIL', sort: true },
      { key: 'username', title: 'USERNAME', sort: true },
      { key: 'provider_user_id', title: 'PROVIDER', sort: true },
      { key: 'created_at', title: 'CREATED AT', sort: true },
      { key: 'updated_at', title: 'UPDATED AT', sort: true }
    ]
  }
  getRow = users => {
    return users.map(d => {
      return {
        ...d,
        avatar: _.get(d, 'avatar.thumb')
      }
    })
  }
  rowRenderer (key, data, rows) {
    if (key === 'created_at' || key === 'updated_at') {
      return moment(data).format()
    }
    if (key === 'id') {
      return (
        <UserIdContainer>
          <Icon name='Profile' /><span>{data}</span> <Copy data={data} />
        </UserIdContainer>
      )
    }
    if (key === 'username') {
      return data || '-'
    }
    if (key === 'provider_user_id') {
      return data || '-'
    }
    if (key === 'email') {
      return data || '-'
    }

    return data
  }

  renderUserPage = ({ data: users, individualLoadingStatus, pagination }) => {
    return (
      <UserPageContainer>
        <TopNavigation divider={this.props.divider} title={'Users'} />
        <SortableTableContainer ref={table => (this.table = table)}>
          <SortableTable
            rows={this.getRow(users)}
            columns={this.getColumns(users)}
            loadingStatus={individualLoadingStatus}
            rowRenderer={this.rowRenderer}
            onClickRow={this.props.onClickRow || this.onClickRow}
            isFirstPage={pagination.is_first_page}
            isLastPage={pagination.is_last_page}
            pagination={false}
            navigation
          />
        </SortableTableContainer>
        <ExportModal open={this.state.exportModalOpen} onRequestClose={this.onRequestCloseExport} />
      </UserPageContainer>
    )
  }

  render () {
    const Fetcher = this.props.fetcher
    return (
      <Fetcher
        {...this.state}
        {...this.props}
        render={this.renderUserPage}
        query={{
          page: queryString.parse(this.props.location.search).page,
          perPage: 15,
          ...createSearchUsersQuery(queryString.parse(this.props.location.search).search),
          ...this.props.query
        }}
        onFetchComplete={this.props.scrollTopContentContainer}
      />
    )
  }
}

export default withRouter(UsersPage)
