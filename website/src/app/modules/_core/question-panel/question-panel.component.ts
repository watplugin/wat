import { Component, HostBinding, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-question-panel',
  templateUrl: './question-panel.component.html',
  styleUrls: ['./question-panel.component.css'],
})
export class QuestionPanelComponent implements OnInit {
  constructor() {}

  @HostBinding('class.mat-expansion-panel') isExpansionPanel: any;
  @Input() iconifyIcon: string = '';
  @Input() title: string = '';

  ngOnInit(): void {}
}
