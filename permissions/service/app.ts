import feathers from '@feathersjs/feathers';
import { PermissionsController, Permission } from './controllers/PermissionsController';

const app = feathers();

// Register the message service on the Feathers application
app.use('messages', new PermissionsController());

// Log every time a new message has been created
app.service('messages').on('created', (message: Permission) => {
  console.log('A new message has been created', message);
});

// A function that creates messages and then logs
// all existing messages on the service
const main = async () => {
  // Create a new message on our message service
  await app.service('messages').create({
    text: 'Hello Feathers'
  });

  // And another one
  await app.service('messages').create({
    text: 'Hello again'
  });
  
  // Find all existing messages
  const messages = await app.service('messages').find();

  console.log('All messages', messages);
};

main();
