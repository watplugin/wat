import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SiteHeaderComponent } from './site-header/site-header.component';
import { DarkModeToggleComponent } from './dark-mode-toggle/dark-mode-toggle.component';
import { HamburgerMenuComponent } from './hamburger-menu/hamburger-menu.component';
import { HorizontalMenuComponent } from './horizontal-menu/horizontal-menu.component';
import { LogoTextButtonComponent } from './logo-text-button/logo-text-button.component';
import { TextButtonComponent } from './text-button/text-button.component';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatIconModule } from '@angular/material/icon';



@NgModule({
  declarations: [
    SiteHeaderComponent,
    DarkModeToggleComponent,
    HamburgerMenuComponent,
    HorizontalMenuComponent,
    LogoTextButtonComponent,
    TextButtonComponent
  ],
  imports: [
    CommonModule,
    MatSlideToggleModule,
    MatIconModule,
  ],
  exports: [
    SiteHeaderComponent
  ]
})
export class SiteHeaderModule { }
