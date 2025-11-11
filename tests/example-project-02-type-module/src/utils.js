export const helperFunction = () => {
  console.log('module helper');
  return true;
};

export const formatData = (data) => {
  return { formatted: data, module: true };
};
