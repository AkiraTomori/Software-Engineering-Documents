import { Injectable } from '@angular/core';

const users = [
  {
    username: 'vue',
    password: 'vue',
  },
  {
    username: 'react',
    password: 'react',
  },
  {
    username: 'angular',
    password: 'angular',
  },
  {
    username: 'full',
    password: 'full',
  },
];

const remoteModules = [
  {
    remoteEntry: 'http://localhost:3003/remoteEntry.js',
    remoteName: 'vue_app',
    exposedModule: 'VueAppLoader',
  },

  {
    remoteEntry: 'http://localhost:3002/remoteEntry.js',
    remoteName: 'react_app',
    exposedModule: 'ReactAppLoader',
  },
  {
    remoteEntry: 'http://localhost:3001/remoteEntry.js',
    remoteName: 'angular_app',
    exposedModule: 'AngularAppLoader',
  },
];

@Injectable({
  providedIn: 'root',
})
export class AppService {
  loggedUser: { username: string; password: string } | null = null;
  authorized_modules: typeof remoteModules = []

  login(username: string, password: string) {
    const user = users.find(
      (item) => item.username === username && item.password === password
    );

    if (!user) return false;

    this.loggedUser = user;

    switch(user.username) {
      case 'full': {
        this.authorized_modules = remoteModules // all modules
        break
      }
      case 'vue': {
        this.authorized_modules = [remoteModules[0]] // takes item at index 0
        break
      }
      case 'react': {
        this.authorized_modules = [remoteModules[1]] // takes item at index 1
        break
      }

      case 'angular': {
        this.authorized_modules = [remoteModules[2]] // takes item at index 1
        break
      }

      default: {
        this.authorized_modules = [remoteModules[0]] // take first
      }
    }

    return true;
  }
}
