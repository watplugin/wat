import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { MatDialogModule } from '@angular/material/dialog';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { BreakpointManagerService } from './breakpoint-manager.service';
import { StyleManagerService } from './style-manager.service';
import { ThemeManagerService } from './theme-manager.service';

export { BreakpointManagerService };
export { StyleManagerService };
export { ThemeManagerService };

@NgModule({
  declarations: [],
  imports: [CommonModule, MatSnackBarModule, MatDialogModule],
  providers: [],
})
export class ServicesModule {}
