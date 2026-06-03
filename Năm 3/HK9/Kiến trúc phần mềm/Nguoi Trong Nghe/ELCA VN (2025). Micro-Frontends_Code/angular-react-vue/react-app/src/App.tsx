import * as React from 'react';
import "./App.css";
import styles from "./App.module.css";
import reactLogo from "../public/react.svg?inline";
import elcaLogo from "../public/elca.png?inline";

export function App() {
  return (
    <div className="content">
      <h1 className={styles.title}>Welcome to react</h1>
      <div>
        <img src="/react.svg" alt="React Logo" width={50} />
      </div>
      <div>
        <img src="/elca.png" alt="ELCA Logo" height={100} />
      </div>

      <div>
        <img src={reactLogo} alt="React Logo" width={50} />
      </div>
      <div>
        <img src={elcaLogo} alt="React Logo" height={100} />
      </div>
    </div>
  );
}
