#
# AppDelegate.rb
# Paperadio
#
# Created by Arun Thampi on 11/19/10.
# Copyright __MyCompanyName__ 2010. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  
  attr_accessor :credentials_window
  attr_accessor :web_view
  
  attr_accessor :username_field, :password_field
  attr_accessor :play_pause_button
  attr_accessor :next_button
  attr_accessor :prev_button
  attr_accessor :now_playing_label
  attr_accessor :activity_indicator

  attr_accessor :instapaper
  
  # Returns the support folder for the application, used to store the Core Data
  # store file.  This code uses a folder named "Paperadio" for
  # the content, either in the NSApplicationSupportDirectory location or (if the
  # former cannot be found), the system's temporary directory.
  def applicationSupportFolder
    paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true)
    basePath = paths[0] || NSTemporaryDirectory()
    basePath.stringByAppendingPathComponent("Paperadio")
  end

  # Creates and returns the managed object model for the application 
  # by merging all of the models found in the application bundle.
  def managedObjectModel
    @managedObjectModel ||= NSManagedObjectModel.mergedModelFromBundles(nil)
  end


  # Returns the persistent store coordinator for the application.  This 
  # implementation will create and return a coordinator, having added the 
  # store for the application to it.  (The folder for the store is created, 
  # if necessary.)
  def persistentStoreCoordinator
    unless @persistentStoreCoordinator
      error = Pointer.new_with_type('@')
    
      fileManager = NSFileManager.defaultManager
      applicationSupportFolder = self.applicationSupportFolder
    
      unless fileManager.fileExistsAtPath(applicationSupportFolder, isDirectory:nil)
        fileManager.createDirectoryAtPath(applicationSupportFolder, attributes:nil)
      end
    
      url = NSURL.fileURLWithPath(applicationSupportFolder.stringByAppendingPathComponent("Paperadio.xml"))
      @persistentStoreCoordinator = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(self.managedObjectModel)
      unless @persistentStoreCoordinator.addPersistentStoreWithType(NSXMLStoreType, configuration:nil, URL:url, options:nil, error:error)
        NSApplication.sharedApplication.presentError(error[0])
      end
    end

    @persistentStoreCoordinator
  end

  # Returns the managed object context for the application (which is already
  # bound to the persistent store coordinator for the application.) 
  def managedObjectContext
    unless @managedObjectContext
      coordinator = self.persistentStoreCoordinator
      if coordinator
        @managedObjectContext = NSManagedObjectContext.new
        @managedObjectContext.setPersistentStoreCoordinator(coordinator)
      end
    end
    
    @managedObjectContext
  end

  # Returns the NSUndoManager for the application.  In this case, the manager
  # returned is that of the managed object context for the application.
  def windowWillReturnUndoManager(window)
    self.managedObjectContext.undoManager
  end

  # Performs the save action for the application, which is to send the save:
  # message to the application's managed object context.  Any encountered errors
  # are presented to the user.
  def saveAction(sender)
    error = Pointer.new_with_type('@')
    unless self.managedObjectContext.save(error)
      NSApplication.sharedApplication.presentError(error[0])
    end
  end

  # Implementation of the applicationShouldTerminate: method, used here to
  # handle the saving of changes in the application managed object context
  # before the application terminates.
  def applicationShouldTerminate(sender)
    error = Pointer.new_with_type('@')
    reply = NSTerminateNow
    
    if managedObjectContext
      if managedObjectContext.commitEditing
        if managedObjectContext.hasChanges && (not managedObjectContext.save(error))
          # This error handling simply presents error information in a panel with an 
          # "Ok" button, which does not include any attempt at error recovery (meaning, 
          # attempting to fix the error.)  As a result, this implementation will 
          # present the information to the user and then follow up with a panel asking 
          # if the user wishes to "Quit Anyway", without saving the changes.

          # Typically, this process should be altered to include application-specific 
          # recovery steps.  

          errorResult = NSApplication.sharedApplication.presentError(error[0])
          
          if errorResult
            reply = NSTerminateCancel
          else
            alertReturn = NSRunAlertPanel(nil, "Could not save changes while quitting. Quit anyway?" , "Quit anyway", "Cancel", nil)
            if alertReturn == NSAlertAlternateReturn
              reply = NSTerminateCancel
            end
          end
        end
      else
        reply = NSTerminateCancel
      end
    end
    
    reply
  end
  
  # Application did Finish Launching
  def applicationDidFinishLaunching(notification)
    self.instapaper = Instapaper.new
    self.instapaper.parent = self
    self.web_view.frameLoadDelegate = self
    
    unless instapaper.has_login_credentials_already?
      NSApp.beginSheet(credentials_window,
                      modalForWindow:window,
                       modalDelegate:nil,
                      didEndSelector:nil,
                         contextInfo:nil)
    else
      instapaper.fetch_first_page
    end
  end
  
  def submitCredentials(sender)
    NSApp.endSheet(credentials_window)
    credentials_window.orderOut(sender)
    
    self.instapaper.login_with!(username_field.stringValue,
                                password_field.stringValue)
  end

  def hideCredentials(sender)
    NSApp.endSheet(credentials_window)
    credentials_window.orderOut(sender)
  end
  
  # Audio Controls
  def playPauseButtonPressed(sender)
    self.instapaper.toggle_play_pause
    self.togglePlayPauseButtonImage
  end
  
  def togglePlayPauseButtonImage
    if self.instapaper.is_speaking?
      self.play_pause_button.image = NSImage.imageNamed("play_graphite")
    else
      self.play_pause_button.image = NSImage.imageNamed("pause_graphite")
    end
  end

  
  def nextStoryButtonPressed(sender)
    self.instapaper.next_story
  end

  def previousStoryButtonPressed(sender)
    self.instapaper.previous_story
  end
  
  # Web View Delegate Methods
  def webView(sender, didStartProvisionalLoadForFrame:frame)
    url_string = frame.provisionalDataSource.request.URL.absoluteString
    if(match = url_string.match(/stories\/(\d+)/im))
      story_index = match[1].to_i
      story_to_get = self.instapaper.stories[story_index]
      
      self.instapaper.get_individual_story_from(story_to_get.url)
    end
  end
  
end
