import React, { Component } from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'

const IconComponent = styled.i`
  vertical-align: middle;
  padding: ${props => (props.button ? '8px' : '0')};
  border-radius: ${props => (props.button ? '2px' : '0')};
  cursor: ${props => (props.button ? 'pointer' : 'inherit')};
  display: inline-block;
  width: 1em;
  height: 1em;
`
export default class Icon extends Component {
  static propTypes = {
    name: PropTypes.string,
    button: PropTypes.bool,
    onClick: PropTypes.func
  }
  render () {
    const { name, button, onClick, ...restProps } = this.props
    return (
      <IconComponent
        {...restProps}
        className={`icon-omisego_${name}`}
        button={button}
        onClick={onClick}
        name={name}
      />
    )
  }
}
