import React, { useState } from 'react';
import propTypes from 'prop-types';
import { Link } from 'react-router-dom';
import { userLogin } from '../../misc/apiRequests';

const Login = ({ handleModal, handleLoader, handleLogin }) => {
  const [credential, setCredential] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = e => {
    e.preventDefault();
    const user = { username: credential, email: credential, password };

    handleLoader(true);
    userLogin(user)
      .then(response => {
        if (response.success) handleLogin(response.user);
        if (!response.success) handleModal(response.errors);
        handleLoader(false);
      });
  };

  return (
    <div id="LoginPage" className="bg-main pt-1">
      <div className="container-md">
        <h2 className="text-center mb-1">Login</h2>
        <form className="login-form" onSubmit={handleSubmit}>
          <h4>Email or Username</h4>
          <input
            type="text"
            value={credential}
            onChange={e => setCredential(e.target.value)}
            minLength="3"
            required
          />
          <h4>Password</h4>
          <input
            type="password"
            value={password}
            onChange={e => setPassword(e.target.value)}
            required
          />
          <button type="submit">Login</button>
          <Link to="/forgot_password">Forgot Password?</Link>
          <Link to="/sign_up">Create an account?</Link>
        </form>
      </div>
    </div>
  );
};

Login.propTypes = {
  handleModal: propTypes.func.isRequired,
  handleLoader: propTypes.func.isRequired,
  handleLogin: propTypes.func.isRequired,
};

export default Login;