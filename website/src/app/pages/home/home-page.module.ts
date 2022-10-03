import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatDividerModule } from '@angular/material/divider';
import { MatExpansionModule } from '@angular/material/expansion';
import { Route, RouterModule } from '@angular/router';
import { CoreModule } from '@src/app/modules/_core/core.module';
import { IconModule } from '@visurel/iconify-angular';
import { HomePageComponent } from './home/home-page.component';

const ROUTES: Route[] = [{ path: '**', component: HomePageComponent }];

@NgModule({
  declarations: [HomePageComponent],
  imports: [
    RouterModule.forChild(ROUTES),
    CommonModule,
    CoreModule,
    MatExpansionModule,
    IconModule,
    MatButtonModule,
    MatDividerModule,
  ],
})
export class HomePageModule {}
