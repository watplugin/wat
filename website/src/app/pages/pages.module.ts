import { NgModule } from '@angular/core';

import { Route, RouterModule } from '@angular/router';

const routes: Route[] = [
  { path: 'home', loadChildren: () => import('./home/home-page.module').then((m) => m.HomePageModule) },

  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: '**', redirectTo: '/home', pathMatch: 'full' },
];

@NgModule({
  declarations: [],
  imports: [
    RouterModule.forRoot(routes, {
      scrollPositionRestoration: 'enabled',
      anchorScrolling: 'enabled',
    }),
  ],
  exports: [RouterModule],
})
export class PagesModule {}
