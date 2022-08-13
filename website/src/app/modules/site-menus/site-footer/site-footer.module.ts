import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SiteFooterComponent } from './site-footer/site-footer.component';



@NgModule({
  declarations: [
    SiteFooterComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    SiteFooterComponent
  ]
})
export class SiteFooterModule { }
