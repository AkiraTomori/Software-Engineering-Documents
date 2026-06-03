import { Component, ViewEncapsulation } from '@angular/core';
import logo from '../assets/angular.png'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  encapsulation: ViewEncapsulation.Emulated
})
export class AppComponent {
  myLogo = logo
}
