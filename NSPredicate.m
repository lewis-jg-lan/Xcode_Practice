#import <Foundation/Foundation.h>

void main()
{
	NSArray *arrayFilter = [NSArray arrayWithObjects:@"pict",@"blackrain",@"ip",nil];
	NSArray *arrayContents = [NSArray arrayWithObjects:@"I am a picture",@"I am a guy",@"I am gagaaa",@"ipad",@"iphone",nil];
	int i=0;
	int count = [arrayFilter count];
	for (int i = 0; i < count; ++i)
	{
		NSString *arrayItem = (NSString*)[arrayFilter objectAtIndex:i];
		NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS%@",arrayItem];
		NSLog(@"Filtered array with filter %@, %@",arrayItem,[arrayContents filteredArrayUsingPredicate:filterPredicate]);
	}
}
