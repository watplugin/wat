import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BgContainerComponent } from './bg-container/bg-container.component';
import { ColumnLayoutComponent } from './column-layout/column-layout.component';
import { FullPageHeaderComponent } from './full-page-header/full-page-header.component';
import { PageHeaderComponent } from './page-header/page-header.component';
import { QuestionPanelComponent } from './question-panel/question-panel.component';
import { SectionComponent } from './section/section.component';
import { SubSectionComponent } from './sub-section/sub-section.component';
import { MatDividerModule } from '@angular/material/divider';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatButtonModule } from '@angular/material/button';
import { MatExpansionModule } from '@angular/material/expansion';
import { BreakableStylesDirective } from './breakable-styles/breakable-styles.directive';
import { SafePipe } from './safe-pipe/safe.pipe';
import { IconModule } from '@visurel/iconify-angular';

export { SafePipe };

@NgModule({
  declarations: [
    BgContainerComponent,
    ColumnLayoutComponent,
    FullPageHeaderComponent,
    PageHeaderComponent,
    QuestionPanelComponent,
    SectionComponent,
    SubSectionComponent,
    BreakableStylesDirective,
    SafePipe,
  ],
  imports: [
    CommonModule,
    MatDividerModule,
    MatButtonToggleModule,
    MatButtonModule,
    MatDividerModule,
    MatExpansionModule,
    IconModule,
  ],
  exports: [
    MatButtonModule,
    BgContainerComponent,
    ColumnLayoutComponent,
    FullPageHeaderComponent,
    PageHeaderComponent,
    QuestionPanelComponent,
    SectionComponent,
    SubSectionComponent,
    BreakableStylesDirective,
    SafePipe,
  ],
})
export class CoreModule {}
