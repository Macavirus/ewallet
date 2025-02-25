import React, { Component } from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import TransactionProvider from '../omg-transaction/transactionProvider'
import { Icon } from '../omg-uikit'
import { withRouter, Link } from 'react-router-dom'
import queryString from 'query-string'
import { compose } from 'recompose'
import { formatReceiveAmountToTotal } from '../utils/formatter'
import moment from 'moment'
import { MarkContainer } from '../omg-page-transaction'
const PanelContainer = styled.div`
  height: 100vh;
  position: fixed;
  z-index: 10;
  right: 0;
  width: 560px;
  background-color: white;
  padding: 40px 30px;
  box-shadow: 0 0 15px 0 rgba(4, 7, 13, 0.1);
  > i {
    position: absolute;
    right: 25px;
    color: ${props => props.theme.colors.S500};
    top: 25px;
    cursor: pointer;
  }
`
const InformationItem = styled.div`
  color: ${props => props.theme.colors.B200};
  :not(:last-child) {
    margin-bottom: 10px;
  }
  p {
    line-height: 1.5;
  }
`
const SubDetailTitle = styled.div`
  margin-top: 10px;
  color: ${props => props.theme.colors.B100};
  margin-bottom: 10px;
  > span {
    padding: 0 5px;
    :first-child {
      padding-left: 0;
    }
  }
  i {
    color: white;
    font-size: 10px;
  }
`
const TransactionInfoContainer = styled.div`
  margin-top: 40px;
  h5 {
    margin-bottom: 10px;
    letter-spacing: 1px;
    background-color: ${props => props.theme.colors.S300};
    display: inline-block;
    padding: 5px 10px;
    border-radius: 2px;
  }
`
const enhance = compose(withRouter)
class TransactionRequestPanel extends Component {
  static propTypes = {
    history: PropTypes.object,
    location: PropTypes.object
  }

  constructor (props) {
    super(props)
    this.state = {}
  }
  onClickClose = () => {
    const searchObject = queryString.parse(this.props.location.search)
    delete searchObject['show-transaction-tab']
    this.props.history.push({
      search: queryString.stringify(searchObject)
    })
  }
  renderTransactionInfo = (transaction, title) => {
    const address = _.get(transaction, 'address')
    const accountName = _.get(transaction, 'account.name')
    const accountId = _.get(transaction, 'account.id')
    const user = _.get(transaction, 'user')
    const tokenId = _.get(transaction, 'token.id')

    return (
      <TransactionInfoContainer>
        <h5>{title}</h5>
        <InformationItem>
          <b>Wallet Address : </b>
          <Link to={{ pathname: `/wallets/${address}`, search: this.props.location.search }}>
            {address}
          </Link>
        </InformationItem>
        {_.get(transaction, 'account') && (
          <InformationItem>
            <b>Account : </b>
            <Link
              to={{ pathname: `/accounts/${accountId}/details`, search: this.props.location.search }}
            >
              {accountName}
            </Link>
          </InformationItem>
        )}
        {user && (
          <InformationItem>
            <b>User : </b>
            <Link to={{ pathname: `/users/${user.id}`, search: this.props.location.search }}>
              {user.id}
            </Link>
          </InformationItem>
        )}
        {user && user.email && (
          <InformationItem>
            <b>User email: </b>
            <Link to={{ pathname: `/users/${user.id}`, search: this.props.location.search }}>
              {user.email}
            </Link>
          </InformationItem>
        )}
        {user && user.provider_user_id && (
          <InformationItem>
            <b>User provider ID: </b>
            <Link to={{ pathname: `/users/${user.id}`, search: this.props.location.search }}>
              {user.provider_user_id}
            </Link>
          </InformationItem>
        )}
        <InformationItem>
          <b>Token : </b>
          <Link to={{ pathname: `/tokens/${tokenId}`, search: this.props.location.search }}>
            {_.get(transaction, 'token.name')}
          </Link>
        </InformationItem>
        <InformationItem>
          <b>Amount : </b>
          {formatReceiveAmountToTotal(
            _.get(transaction, 'amount'),
            _.get(transaction, 'token.subunit_to_unit')
          )}{' '}
          {_.get(transaction, 'token.symbol')}
        </InformationItem>
      </TransactionInfoContainer>
    )
  }
  renderExchangeInfo = ({ exchange }) => {
    const exchangeWalletAddress = _.get(exchange, 'exchange_wallet_address')
    return (
      <TransactionInfoContainer>
        <h5>{'Exchange'}</h5>
        <InformationItem>
          <b>Rate : </b>1 {_.get(exchange, 'exchange_pair.from_token.symbol')} :{' '}
          {_.get(exchange, 'exchange_pair.rate')} {_.get(exchange, 'exchange_pair.to_token.symbol')}
        </InformationItem>
        <InformationItem>
          <b>Exchange wallet address : </b>
          <Link
            to={{
              pathname: `/wallets/${exchangeWalletAddress}`,
              search: this.props.location.search
            }}
          >
            {exchangeWalletAddress}
          </Link>
        </InformationItem>
      </TransactionInfoContainer>
    )
  }
  render = () => {
    return (
      <TransactionProvider
        transactionId={queryString.parse(this.props.location.search)['show-transaction-tab']}
        render={({ transaction }) => {
          return (
            <PanelContainer>
              <Icon name='Close' onClick={this.onClickClose} />
              <h4>Transaction {transaction.id}</h4>
              <SubDetailTitle>
                <span>
                  <MarkContainer status={transaction.status}>
                    {transaction.status === 'failed' ? (
                      <Icon name='Close' />
                    ) : (
                      <Icon name='Checked' />
                    )}
                  </MarkContainer>
                  <span>{_.capitalize(transaction.status)}</span>
                </span>{' '}
                | <span>{moment(transaction.created_at).format()}</span>
              </SubDetailTitle>
              {_.get(transaction, 'error_description') && (
                <InformationItem style={{ color: '#FC7166' }}>
                  <p>{_.get(transaction, 'error_description')}</p>
                </InformationItem>
              )}
              {this.renderTransactionInfo(transaction.from, 'From')}
              {this.renderTransactionInfo(transaction.to, 'To')}
              {_.get(transaction, 'exchange.exchange_pair') && this.renderExchangeInfo(transaction)}
            </PanelContainer>
          )
        }}
      />
    )
  }
}

export default enhance(TransactionRequestPanel)
