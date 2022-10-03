import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SiteFooterModule } from './site-footer/site-footer.module';
import { SiteHeaderModule } from './site-header/site-header.module';

@NgModule({
  declarations: [],
  imports: [CommonModule, SiteHeaderModule, SiteFooterModule],
  exports: [SiteHeaderModule, SiteFooterModule],
})
export class SiteMenusModule {}
