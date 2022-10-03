import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { IconModule } from '@visurel/iconify-angular';
import { SiteFooterComponent } from './site-footer/site-footer.component';

@NgModule({
  declarations: [SiteFooterComponent],
  imports: [CommonModule, IconModule, MatButtonModule],
  exports: [SiteFooterComponent],
})
export class SiteFooterModule {}
