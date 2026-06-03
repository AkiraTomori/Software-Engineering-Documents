# MyWorkspace

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 18.2.10.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The application will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via a platform of your choice. To use this command, you need to first add a package that implements end-to-end testing capabilities.

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI Overview and Command Reference](https://angular.dev/tools/cli) page.


Building large-scale applications can become overwhelming when dealing with multiple features and teams. Micro Frontend Architecture allows you to break down the application into smaller, maintainable modules, enabling independent deployments and updates. In this guide, we'll walk you through setting up an Angular Micro Frontend Application using Native Federation.

# Table of Contents
Building Modular Angular Applications with Micro Frontends and Native Federation
Table of Contents
Setting Up Your Angular Workspace
Generate Applications
Native Federation Setup
Configure Host (Shell) Application
Configuring Remote (Todo) Application
Adding Routes in Shell
## Setting Up Your Angular Workspace
Begin by creating a new Angular workspace without an initial application:
```
ng new my-workspace --create-application=false
```
This sets up a clean workspace where we can generate individual applications within the micro frontend architecture.

## Generate Applications
We will now generate two applications: Shell and Todo. The shell will act as the host, while Todo will be a remote module.
```
ng generate application shell --prefix app-shell
ng generate application todo --prefix app-todo
```
This command creates two Angular applications within the workspace, each with its own prefix to ensure that component selectors don’t conflict.

## Native Federation Setup
To enable micro frontends, we use Native Federation. Install the necessary package with the following command:
```
npm i -D @angular-architects/native-federation
```
Native Federation simplifies managing micro frontends by allowing dynamic imports and independent deployments for each app.

## Configure Host (Shell) Application
To turn your shell application into a host that loads remote applications, run:
```
ng g @angular-architects/native-federation:init --project shell --port 4200 --type dynamic-host
```
This sets up the Shell as a dynamic host that will fetch and load remote modules during runtime. The application will run on port 4200.

## Configuring Remote (Todo) Application
Now, let's configure the Todo application as a remote module, which will be loaded into the shell.
```
ng g @angular-architects/native-federation:init --project todo --port 4201 --type remote
```

The Todo application will now be served on port 4201 as a remote module. This setup allows the shell to dynamically load this module as part of the micro frontend architecture.

Adding Routes in Shell
To load the Todo application within the Shell, you need to configure routes. Here's how to update the routing configuration in the shell:

Generate component in shell application
```
ng g c pages/home --project shell
Now, add below code into shell/src/app/app.routes.ts

import { Routes } from '@angular/router';
import { loadRemoteModule } from '@angular-architects/native-federation';
import { HomeComponent } from './pages/home/home.component';

export const routes: Routes = [
    { path: '', component: HomeComponent },
    {
        path: 'todo',
        loadComponent: () =>
            loadRemoteModule('todo', './Component').then((m) => m.AppComponent),
    },
    {
        path: '**',
        component: HomeComponent,
    },
];
```
In this example:

HomeComponent serves as the default route.
The route /todo dynamically loads the Todo remote module using loadRemoteModule.
A wildcard route (**) ensures that any unknown path redirects to the home page.
Now, run both application

ng serve shell
ng serve todo
Add below code in shell/src/app/app.component.html
```
<ul>
  <li><a routerLink="/">Shell</a></li>
  <li><a routerLink="/todo">Todo</a></li>
</ul>
<router-outlet></router-outlet>
```
Test your application and navigate to todo application

By following these steps, you'll have a fully functioning Angular micro frontend application with a host and remote setup using Native Federation. This architecture is ideal for large-scale projects where modularity, scalability, and independent deployments are crucial.
