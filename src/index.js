import React, { StrictMode } from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router } from 'react-router-dom';
import './assets/css/index.css';
import App from './App';
import ScrollToTop from './components/misc/pageScrollReset'; // Scrolls page to top on route switch



ReactDOM.render(
  <Router>
    <ScrollToTop />
    <StrictMode>
      <App />
    </StrictMode>
  </Router>,
  document.getElementById('root'),
);

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
