import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SiteMenusModule } from './modules/site-menus/site-menus.module';
import { CoreModule } from './modules/_core/core.module';
import { PagesModule } from './pages/pages.module';

@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule, AppRoutingModule, BrowserAnimationsModule, CoreModule, SiteMenusModule, PagesModule],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
