import React from 'react'
import ReactDOM from 'react-dom'

import Results from './components/Results'

ReactDOM.render(
  <Results items={railsItems} finished={finishedItems} queued={queuedItems}/>,
  document.getElementById('results')
)