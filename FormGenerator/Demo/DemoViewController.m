//
//  DemoViewController.m
//  FormGenerator
//
//  Created by Nikita Levintsov on 11/11/14.
//  Copyright (c) 2014 Nikita Levintsov. All rights reserved.
//

#import "DemoViewController.h"
#import "DefaultForm.h"
#import "ModalFormTableViewController.h"
#import "BaseFormDataSource.h"
#import "ResultViewController.h"
@interface DemoViewController ()
@property (nonatomic) NSString * aText;
@property (nonatomic, strong) IBOutlet UIButton * btnGenerateForm;
@property (nonatomic, strong) IBOutlet UITextView  * tvTargetJSON;
@end

@implementation DemoViewController
static NSString * formSegueIdentifier = @"ShowFormSegue";
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cardLimit_v04" ofType:@"json"];
    NSError * error = nil;
    NSString * value = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    self.tvTargetJSON.text = value;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:formSegueIdentifier]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cardLimit_v04" ofType:@"json"];
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        DefaultForm * form = [[DefaultForm alloc] initWithJSONData:data];
        ModalFormTableViewController * vc = (ModalFormTableViewController *)[(UINavigationController *)[segue destinationViewController] topViewController];
        BaseFormDataSource *ds = [[BaseFormDataSource alloc] initWithForm:form];
        vc.dataSource = ds;
        vc.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"PushResultController"]) {
        ResultViewController * vc = (ResultViewController *)segue.destinationViewController;
        [vc setText:self.aText];
    }
}

#pragma mark - FormViewControllerDelegate
- (void)formControllerDidCancelForm:(BaseFormTableViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)formController:(BaseFormTableViewController *)controller didSubmitForm:(NSString *)xmlForm {
    self.aText = xmlForm;
    NSLog(@"result xml is %@", xmlForm);
    [self dismissViewControllerAnimated:YES completion:^{

        [self performSegueWithIdentifier:@"PushResultController" sender:self];
        
    }];
    
    
}


@end
