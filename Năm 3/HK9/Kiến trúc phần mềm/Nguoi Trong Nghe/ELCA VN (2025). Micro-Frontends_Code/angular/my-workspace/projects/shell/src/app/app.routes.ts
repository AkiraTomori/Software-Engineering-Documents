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
