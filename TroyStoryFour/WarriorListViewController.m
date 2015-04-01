//
//  ViewController.m
//  TroyStoryFour
//
//  Created by Rockstar. on 3/31/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "WarriorListViewController.h"
#import "AppDelegate.h"

@interface WarriorListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSManagedObjectContext *moc;
@property NSArray *warriors;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isToggled;

@end

@implementation WarriorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;
    [self load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addWarrior:(UITextField *)sender {
    NSManagedObject *warrior = [NSEntityDescription insertNewObjectForEntityForName:@"Warrior" inManagedObjectContext:self.moc];

    int rand = arc4random() % 10;
    [warrior setValue:sender.text forKey:@"name"];
    [warrior setValue:[NSNumber numberWithInt:rand] forKey:@"prowess"];
    [self.moc save:nil];
    [self load];
    sender.text = @"";
    [sender resignFirstResponder];
}

- (IBAction)prowessToggle:(id)sender {
    self.isToggled = !self.isToggled;

    [self load];
}

- (void)load {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Warrior"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptorTwo = [[NSSortDescriptor alloc] initWithKey:@"prowess" ascending:YES];

    if (self.isToggled) {
        request.predicate = [NSPredicate predicateWithFormat:@"prowess <= 5"];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"prowess >= 5"];
    }

    request.sortDescriptors = @[sortDescriptor, sortDescriptorTwo];
    self.warriors = [self.moc executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.warriors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *warrior = self.warriors[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [warrior valueForKey:@"name"];
    cell.detailTextLabel.text = [[warrior valueForKey:@"prowess"] stringValue];

    return cell;
}

@end
