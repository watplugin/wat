import { TestBed } from '@angular/core/testing';

import { BreakpointManagerService } from './breakpoint-manager.service';

describe('BreakpointManagerService', () => {
  let service: BreakpointManagerService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BreakpointManagerService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
