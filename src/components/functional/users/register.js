import React, { useState } from 'react';
import propTypes from 'prop-types';
import { userRegister } from '../../misc/apiRequests';
import ConfirmPage from '../../presentational/confirmPage';

const Register = ({ handleModal, handleLoader }) => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirm, setPasswordConfirm] = useState('');
  const [message, setMessage] = useState('');
  const [userCreds, setUserCreds] = useState({});
  const [emailConfirm, setEmailConfirm] = useState(false);

  const handleSubmit = e => {
    e.preventDefault();
    if (password !== passwordConfirm) {
      return handleModal(["Password doesn't Match Confirmation!"]);
    }

    const user = {
      username: username.trim(),
      email: email.trim(),
      password,
      password_confirmation: passwordConfirm,
    };

    setUserCreds({ username: username.trim(), email: email.trim() });

    handleLoader(true);
    userRegister(user)
      .then(response => {
        if (response.success) { setMessage(response.message); setEmailConfirm(true); }
        if (!response.success) handleModal(response.errors);
        handleLoader(false);
      });
  };

  return emailConfirm
    ? <ConfirmPage user={userCreds} />
    : (
      <div id="LoginPage" className="bg-main pt-1">
        <div className="container-md">
          <h2 className="text-center mb-1">Register New User</h2>
          <form className="login-form" onSubmit={handleSubmit}>
            <h4>Username</h4>
            <input
              type="text"
              value={username}
              onChange={e => setUsername(e.target.value)}
              minLength="3"
              required
            />
            <h4>Email</h4>
            <input
              type="text"
              value={email}
              onChange={e => setEmail(e.target.value)}
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
            <h4>Password Confirmation</h4>
            <input
              type="password"
              value={passwordConfirm}
              onChange={e => setPasswordConfirm(e.target.value)}
              required
            />
            <button type="submit">Register</button>
          </form>

          <h4 className="text-center p-1">{message}</h4>
        </div>
      </div>
    );
};

Register.propTypes = {
  handleModal: propTypes.func.isRequired,
  handleLoader: propTypes.func.isRequired,
};

export default Register;