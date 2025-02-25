import React, { Component } from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import { withRouter, Link } from 'react-router-dom'
import { compose } from 'recompose'
import moment from 'moment'

import WalletProvider from '../omg-wallet/walletProvider'
import { Button, Icon } from '../omg-uikit'
import TopNavigation from '../omg-page-layout/TopNavigation'
import Section, { DetailGroup } from '../omg-page-detail-layout/DetailSection'
import CreateTransactionModal from '../omg-create-transaction-modal'
import { formatReceiveAmountToTotal } from '../utils/formatter'
import Copy from '../omg-copy'
import CONSTANT from '../constants'

const WalletDetailContainer = styled.div`
  padding-bottom: 20px;
  button i {
    margin-right: 10px;
  }
`
const ContentDetailContainer = styled.div`
  display: flex;
  flex-wrap: wrap;
`
const DetailContainer = styled.div`
  flex: 1 1 auto;
  :first-child {
    margin-right: 20px;
  }
`
const ContentContainer = styled.div`
  display: inline-block;
  width: 100%;
`
const ErrorPageContainer = styled.div`
  text-align: center;
  h4 {
    margin-top: 20px;
  }
  img {
    margin-top: 100px;
    width: 500px;
    height: 350px;
    margin-bottom: 30px;
  }
`
const enhance = compose(
  withRouter
)
class WalletDetaillPage extends Component {
  static propTypes = {
    match: PropTypes.object,
    divider: PropTypes.bool
  }
  state = {
    createTransactionModalOpen: false
  }
  onRequestClose = () => {
    this.setState({ createTransactionModalOpen: false })
  }
  onClickCreateTransaction = e => {
    this.setState({ createTransactionModalOpen: true })
  }
  renderTopBar = wallet => {
    return (
      <TopNavigation
        secondaryAction={false}
        divider={this.props.divider}
        title={wallet.name}
        buttons={[
          <Button size='small' onClick={this.onClickCreateTransaction} key='transfer'>
            <Icon name='Transaction' /><span>Transfer</span>
          </Button>
        ]}
      />
    )
  }
  renderDetail = wallet => {
    return (
      <Section title={{ text: 'Details', icon: 'Portfolio' }}>
        <DetailGroup>
          <b>Address:</b> <span>{wallet.address}</span> <Copy data={wallet.address} />
        </DetailGroup>
        <DetailGroup>
          <b>Name:</b> <span>{wallet.name}</span>
        </DetailGroup>
        <DetailGroup>
          <b>Wallet Identifier:</b> <span>{wallet.identifier}</span>
        </DetailGroup>
        {wallet.account && (
          <DetailGroup>
            <b>Account Owner:</b>{' '}
            <Link to={`/accounts/${wallet.account.id}/details`}>
              {_.get(wallet, 'account.name', '-')}
            </Link>
          </DetailGroup>
        )}
        {wallet.user && (
          <DetailGroup>
            <b>User:</b>{' '}
            <Link to={`/users/${wallet.user.id}`}>{_.get(wallet, 'user.id', '-')}</Link>
          </DetailGroup>
        )}
        <DetailGroup>
          <b>Created At:</b> <span>{moment(wallet.created_at).format()}</span>
        </DetailGroup>
        <DetailGroup>
          <b>Updated At:</b> <span>{moment(wallet.updated_at).format()}</span>
        </DetailGroup>
      </Section>
    )
  }
  renderBalances = wallet => {
    return (
      <Section title={{ text: 'Balances', icon: 'Token' }}>
        {wallet.balances.map(balance => {
          return (
            <DetailGroup key={balance.token.id}>
              <b>{balance.token.name}</b>{' '}
              <span>
                {formatReceiveAmountToTotal(balance.amount, balance.token.subunit_to_unit)}{' '}
                {balance.token.symbol}
              </span>
            </DetailGroup>
          )
        })}
      </Section>
    )
  }
  renderWalletDetailContainer = wallet => {
    return (
      <div>
        <ContentContainer>
          {this.renderTopBar(wallet)}
          <ContentDetailContainer>
            <DetailContainer>{this.renderDetail(wallet)}</DetailContainer>
            <DetailContainer>{this.renderBalances(wallet)}</DetailContainer>
          </ContentDetailContainer>
        </ContentContainer>
        <CreateTransactionModal
          fromAddress={wallet.address}
          onRequestClose={this.onRequestClose}
          open={this.state.createTransactionModalOpen}
        />
      </div>
    )
  }
  renderErrorPage (error) {
    return (
      <ErrorPageContainer>
        <img src={require('../../statics/images/empty_state.png')} />
        <h2>{error.code}</h2>
        <p>{error.description}</p>
      </ErrorPageContainer>
    )
  }

  renderWalletDetailPage = ({ wallet, loadingStatus, result }) => {
    return (
      <WalletDetailContainer>
        {wallet
          ? this.renderWalletDetailContainer(wallet)
          : loadingStatus === CONSTANT.LOADING_STATUS.FAILED && this.renderErrorPage(result.error)}
      </WalletDetailContainer>
    )
  }
  render () {
    return (
      <WalletProvider
        render={this.renderWalletDetailPage}
        walletAddress={this.props.match.params.walletAddress}
        {...this.state}
        {...this.props}
      />
    )
  }
}

export default enhance(WalletDetaillPage)
