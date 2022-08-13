import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { ClassesModule } from '../classes/_classes.module';

export * from './breakpoints';

@NgModule({
  declarations: [],
  imports: [CommonModule, ClassesModule],
  providers: [],
})
export class SettingsModule {}
